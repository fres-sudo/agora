// Regression test for GitHub issue #5: stock adjustments in
// InventoryRepositoryImpl were performed as a Dart-side read-then-write
// (get quantity, compute new value, write it back) with no transaction
// wrapping the two steps. When two writers adjusted the same product
// concurrently (e.g. two POS terminals selling the last few units), both
// could read the same starting quantity and the second write would
// silently clobber the first, losing one of the decrements.
//
// This test exercises the real Drift DAOs against an in-memory SQLite
// database (no mocks) so that the async interleaving Dart actually
// performs between the `await` points of concurrent `adjustStock` calls
// is representative of the real race. Before the fix (atomic SQL
// `UPDATE ... SET quantity = quantity + delta` wrapped in a transaction),
// this test reliably lost updates and failed.
import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_inventory/data/repositories/inventory_repository_impl.dart';
import 'package:feature_inventory/data/sources/local/daos/stock_movements_dao.dart';
import 'package:feature_inventory/data/sources/local/daos/stocks_dao.dart';
import 'package:inventory_contracts/repositories/inventory_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result/result.dart';

void main() {
  late AgoraDatabase db;
  late InventoryRepositoryImpl repository;

  const productId = 1;

  setUp(() async {
    db = AgoraDatabase(NativeDatabase.memory());
    repository = InventoryRepositoryImpl(
      stocksDao: StocksDao(db),
      stockMovementsDao: StockMovementsDao(db),
    );

    // Seed a product row (stocks.productId has a FK to products.id).
    await db
        .into(db.productsTable)
        .insert(ProductsTableCompanion.insert(name: 'Widget'));
  });

  tearDown(() async => db.close());

  test(
    'concurrent adjustStock calls on the same product do not lose updates',
    () async {
      const startingQuantity = 50;
      const concurrentDecrements = 20;

      final setResult = await repository.setStock(
        productId: productId,
        quantity: startingQuantity,
        reason: 'initial stock',
      );
      expect(setResult, isA<Ok<Stock>>());

      // Fire many concurrent decrements, simulating multiple POS terminals
      // selling the same product at the same time. Each call reads,
      // decrements by 1 and writes back — the exact read-modify-write
      // shape that used to lose updates without a transaction.
      final results = await Future.wait(
        List.generate(
          concurrentDecrements,
          (_) => repository.decrementForOrder(
            productId: productId,
            quantity: 1,
            orderId: 1,
          ),
        ),
      );

      expect(results, everyElement(isA<Ok<Stock>>()));

      final quantityResult = await repository.getStockQuantity(productId);
      expect(quantityResult, isA<Ok<int>>());
      final finalQuantity = (quantityResult as Ok<int>).value;

      expect(
        finalQuantity,
        startingQuantity - concurrentDecrements,
        reason:
            'every concurrent decrement must be reflected in the final '
            'quantity; a value higher than expected means an update was '
            'lost to a race between concurrent adjustStock calls',
      );

      // The movement history must also have one entry per decrement (plus
      // the initial `setStock` seed movement) — further evidence that no
      // writer's operation was silently dropped.
      final movementsResult = await repository.getMovementHistory(
        productId: productId,
      );
      expect(movementsResult, isA<Ok<List<StockMovement>>>());
      final movements = (movementsResult as Ok<List<StockMovement>>).value;
      expect(movements, hasLength(concurrentDecrements + 1));
    },
  );

  test(
    'concurrent adjustStock calls mixing increments and decrements settle on the correct total',
    () async {
      const startingQuantity = 0;

      await repository.setStock(
        productId: productId,
        quantity: startingQuantity,
        reason: 'initial stock',
      );

      const increments = 15;
      const decrements = 5;

      await Future.wait([
        ...List.generate(
          increments,
          (_) => repository.adjustStock(
            productId: productId,
            delta: 1,
            reason: 'restock',
          ),
        ),
        ...List.generate(
          decrements,
          (_) => repository.adjustStock(
            productId: productId,
            delta: -1,
            reason: 'sale',
          ),
        ),
      ]);

      final quantityResult = await repository.getStockQuantity(productId);
      final finalQuantity = (quantityResult as Ok<int>).value;

      expect(finalQuantity, startingQuantity + increments - decrements);
    },
  );
}
