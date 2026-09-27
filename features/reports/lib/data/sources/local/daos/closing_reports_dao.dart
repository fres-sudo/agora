import 'package:database/database.dart';
import 'package:drift/drift.dart';

part 'closing_reports_dao.g.dart';

@DriftAccessor(tables: [ClosingReportsTable])
class ClosingReportsDao extends DatabaseAccessor<AgoraDatabase>
    with _$ClosingReportsDaoMixin {
  ClosingReportsDao(super.db);

  /// Streams all non-deleted closing reports, newest first.
  Stream<List<ClosingReportEntity>> watchAll() =>
      (select(attachedDatabase.closingReportsTable)
            ..where((t) => t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  /// Inserts a new closing report row and returns the generated id.
  Future<int> insertRecord(ClosingReportsTableCompanion companion) =>
      into(attachedDatabase.closingReportsTable).insert(companion);
}
