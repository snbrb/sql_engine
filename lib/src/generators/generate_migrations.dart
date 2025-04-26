import '../../sql_engine.dart';
import 'extract_sql_create_table_query.dart';

/// Create SQL migrations by diffing consecutive SqlSchema versions.
List<SqlEngineMigration> generateMigrations(
  String tableName,
  List<SqlSchema> schemas,
) {
  final List<SqlEngineMigration> migrations = <SqlEngineMigration>[];

  // loop of all schemas
  for (int i = 1; i < schemas.length; i++) {
    // 1 before last is from[previous]
    final SqlSchema from = schemas[i - 1];
    // current schema
    final SqlSchema to = schemas[i];

    final int version = to.version;
    final List<String> up = <String>[];
    //final List<String> down = <String>[];

    final Map<String, SqlColumn> oldCols = <String, SqlColumn>{
      for (final SqlColumn col in from.columns) col.name: col,
    };

    final Map<String, SqlColumn> newCols = <String, SqlColumn>{
      for (final SqlColumn col in to.columns) col.name: col,
    };

    // 1. Handle renamed columns
    for (final SqlColumn col in to.columns) {
      if (col.renamedFrom != null && oldCols.containsKey(col.renamedFrom)) {
        up.add(
          'ALTER TABLE $tableName RENAME COLUMN ${col.renamedFrom} TO ${col.name};',
        );
        // NOTE: No easy down migration
      }
    }

    // 2. Handle added columns
    for (final SqlColumn col in to.columns) {
      final bool alreadyExists =
          oldCols.containsKey(col.name) ||
          col.renamedFrom != null && oldCols.containsKey(col.renamedFrom);
      if (!alreadyExists) {
        final StringBuffer sb = StringBuffer();
        sb.write(
          'ALTER TABLE $tableName ADD COLUMN ${col.name} ${col.type ?? 'TEXT'}',
        );

        if (!col.nullable) {
          if (col.defaultValue == null) {
            // Invalid in SQLite, warn by skipping or re-creating table in future
            sb.write(
              ' /* WARNING: Cannot add NOT NULL column without default */',
            );
          } else {
            sb.write(' NOT NULL');
          }
        }

        if (col.defaultValue != null) {
          sb.write(' DEFAULT ${formatSqlDefault(col.defaultValue)}');
        }

        up.add('$sb;');
      }
    }

    // 3. Detect removed columns (warn only)
    for (final SqlColumn col in from.columns) {
      final bool stillExists =
          newCols.containsKey(col.name) ||
          to.columns.any((SqlColumn c) => c.renamedFrom == col.name);
      if (!stillExists) {
        up.add(
          '-- WARNING: Column "${col.name}" removed. SQLite does not support DROP COLUMN.',
        );
      }
    }

    // 4. Fallback: if no changes were detected
    if (up.isEmpty) {
      up.add('-- No changes from v${from.version} to v${to.version}');
    }

    // 5. Build migration object
    migrations.add(
      SqlEngineMigration(
        version: version,
        up: up.join('\n'),
        down: '-- Down migration for version $version not implemented.',
        description: 'Upgrade $tableName to version $version',
      ),
    );
  }

  return migrations;
}
