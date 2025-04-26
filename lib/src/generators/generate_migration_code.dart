import '../classes/sql_engine_migration.dart';

/// Convert a list of SqlEngineMigration objects into Dart source code
/// that can be embedded into a generated table class.
String generateMigrationCode(List<SqlEngineMigration> migrations) {
  final List<String> lines = <String>[];

  for (final SqlEngineMigration migration in migrations) {
    lines.add('''
    const SqlEngineMigration(
      version: ${migration.version},
      up: r"""${migration.up.trim()}""",
      down: r"""${migration.down.trim()}""",
      description: '${migration.description}',
    ),
''');
  }

  return lines.join();
}
