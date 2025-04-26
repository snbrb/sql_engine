import 'dart:developer';

import '../../sql_engine.dart';

/// Build a SQL `CREATE TABLE` statement from schema
String extractSqlCreateTableQuery(String tableName, SqlSchema schema) {
  final List<String> columnDefs = <String>[];
  log(schema.columns.toString());
  for (final SqlColumn col in schema.columns) {
    final StringBuffer buffer =
        StringBuffer()..write('${col.name} ${col.type ?? 'TEXT'}');

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

  final String result = '''
CREATE TABLE $tableName (
  ${columnDefs.join(',\n  ')}
);
''';

  return result;
}

String formatSqlDefault(Object? value) {
  if (value is String) {
    return "'$value'";
  }
  return value.toString();
}
