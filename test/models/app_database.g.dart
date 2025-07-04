// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison, unnecessary_cast, invalid_null_aware_operator

part of 'app_database.dart';

// **************************************************************************
// SqlDatabaseGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

class $AppDatabase extends SqlEngineDatabase {
  $AppDatabase({
    String dbPath = ':memory:',
    JournalMode mode = JournalMode.delete,
  }) : super(dbPath: dbPath, version: 1, mode: mode, migrations: _migrations) {
    registerTable(_tables);
  }

  static const List<SqlEngineTable> _tables = [
    UserTable(),
    OrderTable(),
    OrderItemTable(),
  ];

  static final List<SqlEngineMigration> _migrations = [
    ...UserTable.migrations,
    ...OrderTable.migrations,
    ...OrderItemTable.migrations,
  ];
}
