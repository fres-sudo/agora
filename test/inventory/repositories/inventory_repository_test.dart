import 'package:database/database.dart';
import 'package:feature_inventory/data/repositories/inventory_repository_impl.dart';
import 'package:feature_inventory/feature_inventory.dart';
import 'package:result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'inventory_repository_test.mocks.dart';

@GenerateMocks([StocksDao, StockMovementsDao])
void main() {
  late MockStocksDao mockStocksDao;
  late MockStockMovementsDao mockStockMovementsDao;
  late InventoryRepositoryImpl repository;

  setUp(() {
    mockStocksDao = MockStocksDao();
    mockStockMovementsDao = MockStockMovementsDao();
    repository = InventoryRepositoryImpl(
      stocksDao: mockStocksDao,
      stockMovementsDao: mockStockMovementsDao,
    );
  });

  const tProductId = 1;
  final tDate = DateTime(2023, 1, 1);
  final tStockEntity = StockEntity(
    id: 1,
    productId: tProductId,
    quantity: 10,
    createdAt: tDate,
    updatedAt: tDate,
    deletedAt: null,
  );
  final tStockMovementEntity = StockMovementEntity(
    id: 1,
    productId: tProductId,
    quantityChange: 5,
    reason: 'test',
    timestamp: tDate,
    createdAt: tDate,
    updatedAt: tDate,
    deletedAt: null,
  );

  group('InventoryRepository', () {
    group('watchStockLevels', () {
      test('maps dao rows (name + qty + trackStock) to StockLevel', () async {
        when(mockStocksDao.watchStockLevels()).thenAnswer(
          (_) => Stream.value(const [
            (productId: 1, name: 'Tagliatelle', quantity: 10, trackStock: true),
            (productId: 2, name: 'Water', quantity: 0, trackStock: false),
          ]),
        );

        final levels = await repository.watchStockLevels().first;

        expect(levels, hasLength(2));
        expect(levels.first.name, 'Tagliatelle');
        expect(levels.first.quantity, 10);
        expect(levels.first.trackStock, isTrue);
        expect(levels[1].trackStock, isFalse);
      });
    });

    group('watchAllStocks', () {
      test('should emit list of stocks from dao', () {
        // Arrange
        when(mockStocksDao.watchAllStocks())
            .thenAnswer((_) => Stream.value([tStockEntity]));

        // Act
        final stream = repository.watchAllStocks();

        // Assert
        expect(
          stream,
          emits([
            (productId: tStockEntity.productId, quantity: tStockEntity.quantity)
          ]),
        );
        verify(mockStocksDao.watchAllStocks()).called(1);
      });
    });

    group('watchStockByProductId', () {
      test('should emit stock from dao when exists', () {
        // Arrange
        when(mockStocksDao.watchStockByProductId(tProductId))
            .thenAnswer((_) => Stream.value(tStockEntity));

        // Act
        final stream = repository.watchStockByProductId(tProductId);

        // Assert
        expect(
          stream,
          emits(
              (productId: tStockEntity.productId, quantity: tStockEntity.quantity)),
        );
        verify(mockStocksDao.watchStockByProductId(tProductId)).called(1);
      });

      test('should emit null from dao when does not exist', () {
        // Arrange
        when(mockStocksDao.watchStockByProductId(tProductId))
            .thenAnswer((_) => Stream.value(null));

        // Act
        final stream = repository.watchStockByProductId(tProductId);

        // Assert
        expect(stream, emits(null));
        verify(mockStocksDao.watchStockByProductId(tProductId)).called(1);
      });
    });

    group('watchLowStocks', () {
      test('should emit low stocks from dao', () {
        // Arrange
        const threshold = 5;
        when(mockStocksDao.watchLowStocks(threshold))
            .thenAnswer((_) => Stream.value([tStockEntity]));

        // Act
        final stream = repository.watchLowStocks(threshold);

        // Assert
        expect(
          stream,
          emits([
            (productId: tStockEntity.productId, quantity: tStockEntity.quantity)
          ]),
        );
        verify(mockStocksDao.watchLowStocks(threshold)).called(1);
      });
    });

    group('watchMovementsByProductId', () {
      test('should emit movements from dao', () {
        // Arrange
        when(mockStockMovementsDao.watchMovementsByProductId(tProductId))
            .thenAnswer((_) => Stream.value([tStockMovementEntity]));

        // Act
        final stream = repository.watchMovementsByProductId(tProductId);

        // Assert
        expect(
          stream,
          emits([
            (
              id: tStockMovementEntity.id,
              productId: tStockMovementEntity.productId,
              quantityChange: tStockMovementEntity.quantityChange,
              reason: tStockMovementEntity.reason,
              timestamp: tStockMovementEntity.timestamp,
            )
          ]),
        );
        verify(mockStockMovementsDao.watchMovementsByProductId(tProductId))
            .called(1);
      });
    });

    group('getStockQuantity', () {
      test('should return quantity from dao when stock exists', () async {
        // Arrange
        when(mockStocksDao.getStockByProductId(tProductId))
            .thenAnswer((_) async => tStockEntity);

        // Act
        final result = await repository.getStockQuantity(tProductId);

        // Assert
        expect(result, isA<Ok<int>>());
        expect((result as Ok<int>).value, tStockEntity.quantity);
        verify(mockStocksDao.getStockByProductId(tProductId)).called(1);
      });

      test('should return 0 from dao when stock does not exist', () async {
        // Arrange
        when(mockStocksDao.getStockByProductId(tProductId))
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.getStockQuantity(tProductId);

        // Assert
        expect(result, isA<Ok<int>>());
        expect((result as Ok<int>).value, 0);
        verify(mockStocksDao.getStockByProductId(tProductId)).called(1);
      });
    });

    group('getStockByProductId', () {
      test('should return stock from dao when exists', () async {
        // Arrange
        when(mockStocksDao.getStockByProductId(tProductId))
            .thenAnswer((_) async => tStockEntity);

        // Act
        final result = await repository.getStockByProductId(tProductId);

        // Assert
        expect(result, isA<Ok<Stock?>>());
        final stock = (result as Ok<Stock?>).value;
        expect(stock?.productId, tStockEntity.productId);
        expect(stock?.quantity, tStockEntity.quantity);
        verify(mockStocksDao.getStockByProductId(tProductId)).called(1);
      });

      test('should return null from dao when does not exist', () async {
        // Arrange
        when(mockStocksDao.getStockByProductId(tProductId))
            .thenAnswer((_) async => null);

        // Act
        final result = await repository.getStockByProductId(tProductId);

        // Assert
        expect(result, isA<Ok<Stock?>>());
        expect((result as Ok<Stock?>).value, null);
        verify(mockStocksDao.getStockByProductId(tProductId)).called(1);
      });
    });

    group('getStocksCount', () {
      test('should return count from dao', () async {
        // Arrange
        when(mockStocksDao.getStocksCount()).thenAnswer((_) async => 10);

        // Act
        final result = await repository.getStocksCount();

        // Assert
        expect(result, isA<Ok<int>>());
        expect((result as Ok<int>).value, 10);
        verify(mockStocksDao.getStocksCount()).called(1);
      });
    });

    group('getMovementHistory', () {
      test('should return movements from dao when productId is provided',
          () async {
        // Arrange
        when(mockStockMovementsDao.getMovementsByProductId(tProductId))
            .thenAnswer((_) async => [tStockMovementEntity]);

        // Act
        final result =
            await repository.getMovementHistory(productId: tProductId);

        // Assert
        expect(result, isA<Ok<List<StockMovement>>>());
        final movements = (result as Ok<List<StockMovement>>).value;
        expect(movements.length, 1);
        expect(movements.first.id, tStockMovementEntity.id);
        verify(mockStockMovementsDao.getMovementsByProductId(tProductId))
            .called(1);
      });

      test('should return empty list when productId is not provided', () async {
        // Act
        final result = await repository.getMovementHistory();

        // Assert
        expect(result, isA<Ok<List<StockMovement>>>());
        expect((result as Ok<List<StockMovement>>).value, isEmpty);
        verifyZeroInteractions(mockStockMovementsDao);
      });
    });

    group('adjustStock', () {
      test('should adjust stock and record movement', () async {
        // Arrange
        const delta = 5;
        const reason = 'restock';
        final updatedQuantity = tStockEntity.quantity + delta;

        // Mock getStockByProductId to return current stock
        when(mockStocksDao.getStockByProductId(tProductId))
            .thenAnswer((_) async => tStockEntity);

        // Mock upsertStock
        when(mockStocksDao.upsertStock(
          productId: tProductId,
          quantity: updatedQuantity,
        )).thenAnswer((_) async {});

        // Mock recordMovement
        when(mockStockMovementsDao.recordMovement(
          productId: tProductId,
          quantityChange: delta,
          reason: reason,
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.adjustStock(
          productId: tProductId,
          delta: delta,
          reason: reason,
        );

        // Assert
        expect(result, isA<Ok<Stock>>());
        final stock = (result as Ok<Stock>).value;
        expect(stock.quantity, updatedQuantity);

        verify(mockStocksDao.getStockByProductId(tProductId)).called(1);
        verify(mockStocksDao.upsertStock(
          productId: tProductId,
          quantity: updatedQuantity,
        )).called(1);
        verify(mockStockMovementsDao.recordMovement(
          productId: tProductId,
          quantityChange: delta,
          reason: reason,
        )).called(1);
      });

      test('should handle adjust stock when stock does not exist', () async {
        // Arrange
        const delta = 5;
        const reason = 'initial';
        const currentQuantity = 0;
        final updatedQuantity = currentQuantity + delta;

        // Mock getStockByProductId to return null
        when(mockStocksDao.getStockByProductId(tProductId))
            .thenAnswer((_) async => null);

        // Mock upsertStock
        when(mockStocksDao.upsertStock(
          productId: tProductId,
          quantity: updatedQuantity,
        )).thenAnswer((_) async {});

        // Mock recordMovement
        when(mockStockMovementsDao.recordMovement(
          productId: tProductId,
          quantityChange: delta,
          reason: reason,
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.adjustStock(
          productId: tProductId,
          delta: delta,
          reason: reason,
        );

        // Assert
        expect(result, isA<Ok<Stock>>());
        final stock = (result as Ok<Stock>).value;
        expect(stock.quantity, updatedQuantity);
      });
    });

    group('setStock', () {
      test('should set stock and record movement if changed', () async {
        // Arrange
        const newQuantity = 20;
        const reason = 'audit';
        final delta = newQuantity - tStockEntity.quantity;

        when(mockStocksDao.getStockByProductId(tProductId))
            .thenAnswer((_) async => tStockEntity);

        when(mockStocksDao.upsertStock(
          productId: tProductId,
          quantity: newQuantity,
        )).thenAnswer((_) async {});

        when(mockStockMovementsDao.recordMovement(
          productId: tProductId,
          quantityChange: delta,
          reason: reason,
        )).thenAnswer((_) async => 1);

        // Act
        final result = await repository.setStock(
          productId: tProductId,
          quantity: newQuantity,
          reason: reason,
        );

        // Assert
        expect(result, isA<Ok<Stock>>());
        final stock = (result as Ok<Stock>).value;
        expect(stock.quantity, newQuantity);

        verify(mockStocksDao.upsertStock(
          productId: tProductId,
          quantity: newQuantity,
        )).called(1);
        verify(mockStockMovementsDao.recordMovement(
          productId: tProductId,
          quantityChange: delta,
          reason: reason,
        )).called(1);
      });

      test('should not record movement if quantity is same', () async {
         // Arrange
        final newQuantity = tStockEntity.quantity;
        const reason = 'audit';

        when(mockStocksDao.getStockByProductId(tProductId))
            .thenAnswer((_) async => tStockEntity);

        when(mockStocksDao.upsertStock(
          productId: tProductId,
          quantity: newQuantity,
        )).thenAnswer((_) async {});

        // Act
        final result = await repository.setStock(
          productId: tProductId,
          quantity: newQuantity,
          reason: reason,
        );

        // Assert
        expect(result, isA<Ok<Stock>>());
        verify(mockStocksDao.upsertStock(
          productId: tProductId,
          quantity: newQuantity,
        )).called(1);
        verifyNever(mockStockMovementsDao.recordMovement(
          productId: anyNamed('productId'),
          quantityChange: anyNamed('quantityChange'),
          reason: anyNamed('reason'),
        ));
      });
    });
  });
}
