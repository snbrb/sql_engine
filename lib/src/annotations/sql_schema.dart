import 'sql_column.dart';

/// Annotation for defining a schema version
class SqlSchema {
  /// The version number of this schema
  final int version;

  /// The columns in this schema version
  /// Can be either a list of strings (column names) or SqlColumn objects
  final List<SqlColumn> columns;

  /// Optional list of seed data maps
  final List<Map<String, dynamic>> seedData;

  const SqlSchema({
    required this.version,
    required this.columns,
    this.seedData = const <Map<String, dynamic>>[],
  });
}
