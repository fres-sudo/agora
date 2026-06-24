// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
abstract class _$AgoraDatabase extends GeneratedDatabase {
  _$AgoraDatabase(QueryExecutor e) : super(e);
  $AgoraDatabaseManager get managers => $AgoraDatabaseManager(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [];
}

class $AgoraDatabaseManager {
  final _$AgoraDatabase _db;
  $AgoraDatabaseManager(this._db);
}
