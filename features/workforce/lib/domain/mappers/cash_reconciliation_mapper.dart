import 'package:database/database.dart';
import '../models/cash_reconciliation.dart';

extension CashReconciliationEntityMapper on CashReconciliationEntity {
  CashReconciliation toModel() => CashReconciliation(
    id: id,
    clockRecordId: clockRecordId,
    expectedCents: expectedCents,
    countedCents: countedCents,
    varianceCents: varianceCents,
    note: note,
    createdAt: createdAt,
  );
}

CashReconciliationsTableCompanion cashReconciliationInsertCompanion({
  required int clockRecordId,
  required int expectedCents,
  required int countedCents,
  String? note,
}) => CashReconciliationsTableCompanion.insert(
  clockRecordId: clockRecordId,
  expectedCents: expectedCents,
  countedCents: countedCents,
  varianceCents: countedCents - expectedCents,
  note: Value(note),
);
