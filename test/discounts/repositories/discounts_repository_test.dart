import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_discounts/data/repositories/discounts_repository_impl.dart';
import 'package:feature_discounts/data/sources/local/daos/discounts_dao.dart';
import 'package:feature_discounts/domain/models/discount.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:result/result.dart';

/// P6-2: usage limits are persisted end-to-end (mapped by the repository and
/// incremented on sale), so `Discount.isValid` can actually enforce them.
void main() {
  late AgoraDatabase db;
  late DiscountsRepositoryImpl repository;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
    repository = DiscountsRepositoryImpl(discountsDao: DiscountsDao(db));
  });

  tearDown(() async => db.close());

  Future<Discount> create(Discount discount) async {
    final result = await repository.createDiscount(discount);
    return (result as Ok<Discount>).value;
  }

  const base = Discount(
    id: 0,
    name: '10% off',
    type: DiscountType.percentage,
    value: 10,
    usageLimit: 2,
  );

  test('createDiscount round-trips usageLimit and usageCount', () async {
    final created = await create(base);

    final fetched =
        (await repository.getDiscountById(created.id) as Ok<Discount?>).value;
    expect(fetched, isNotNull);
    expect(fetched!.usageLimit, 2);
    expect(fetched.usageCount, 0);
  });

  test('incrementUsage grows usageCount and drives isValid to false at the '
      'limit', () async {
    final created = await create(base);

    await repository.incrementUsage(created.id);
    var current =
        (await repository.getDiscountById(created.id) as Ok<Discount?>).value!;
    expect(current.usageCount, 1);
    expect(current.isValid, isTrue); // 1 < limit(2)

    await repository.incrementUsage(created.id);
    current =
        (await repository.getDiscountById(created.id) as Ok<Discount?>).value!;
    expect(current.usageCount, 2);
    expect(current.isValid, isFalse); // reached limit
  });

  test('a null usageLimit means unlimited use', () async {
    final created = await create(
      base.copyWith(name: 'Unlimited', usageLimit: null),
    );

    await repository.incrementUsage(created.id);
    await repository.incrementUsage(created.id);
    final current =
        (await repository.getDiscountById(created.id) as Ok<Discount?>).value!;
    expect(current.usageCount, 2);
    expect(current.isValid, isTrue);
  });

  test('updateDiscount preserves usageCount (it is not an editable field)',
      () async {
    final created = await create(base);
    await repository.incrementUsage(created.id);

    await repository.updateDiscount(created.copyWith(name: 'Renamed'));

    final current =
        (await repository.getDiscountById(created.id) as Ok<Discount?>).value!;
    expect(current.name, 'Renamed');
    expect(current.usageCount, 1);
  });
}
