import '../../sql_engine.dart';

String extractSqlCreateTableQuery(String tableName, SqlSchema schema) {
  final List<String> columnDefs = <String>[];

  for (final SqlColumn col in schema.columns) {
    final StringBuffer buffer =
        StringBuffer()..write('${col.name} ${col.type.sqlName}');

    if (col.primaryKey) {
      buffer.write(' PRIMARY KEY');
    }
    if (col.autoincrement) {
      buffer.write(' AUTOINCREMENT');
    }
    if (!col.nullable) {
      buffer.write(' NOT NULL');
    }
    if (col.unique) {
      buffer.write(' UNIQUE');
    }
    if (col.defaultValue != null) {
      buffer.write(' DEFAULT ${formatSqlDefault(col.defaultValue)}');
    }
    if (col.references != null && col.referenceColumn != null) {
      buffer.write(' REFERENCES ${col.references}(${col.referenceColumn})');
    }

    columnDefs.add(buffer.toString());
  }

  return '''
CREATE TABLE $tableName (
  ${columnDefs.join(',\n  ')}
);
''';
}

String formatSqlDefault(Object? value) {
  if (value == null) {
    return 'NULL';
  }

  if (value is String) {
    return "'${value.replaceAll("'", "''")}'"; // escape single quotes
  }

  if (value is bool) {
    return value ? '1' : '0'; // SQLite uses 1/0 for booleans
  }

  if (value is DateTime) {
    return "'${value.toIso8601String()}'";
  }

  return value.toString(); // int, double, etc.
}
