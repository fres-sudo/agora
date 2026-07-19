import 'package:bloc_exports/bloc_exports.dart';

part 'cash_reconciliation.freezed.dart';

@freezed
abstract class CashReconciliation with _$CashReconciliation {
  const factory CashReconciliation({
    required int id,
    required int clockRecordId,
    required int expectedCents,
    required int countedCents,
    required int varianceCents,
    String? note,
    DateTime? createdAt,
  }) = _CashReconciliation;

  const CashReconciliation._();

  bool get isBalanced => varianceCents == 0;

  bool get hasShortfall => varianceCents < 0;
}
