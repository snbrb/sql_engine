/// generate app database class
String generateAppDatabaseClass({
  required String dbClassName,
  required int version,
  required String tableList,
  required String migrationList,
}) => '''
// GENERATED CODE - DO NOT MODIFY BY HAND

class \$$dbClassName extends SqlEngineDatabase {
  \$$dbClassName({
    String dbPath = ':memory:',
    JournalMode mode = JournalMode.delete,
  }) : super(
          dbPath: dbPath,
          version: $version,
          mode: mode,
          migrations: _migrations,
        ) {
    registerTable(_tables);
  }

  static const List<SqlEngineTable> _tables = [
    $tableList
  ];

  static final List<SqlEngineMigration> _migrations = [
    $migrationList
  ];
}
''';
