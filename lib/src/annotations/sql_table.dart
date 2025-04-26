/// class as a SQL table
class SqlTable {
  /// The name of the table in the database
  final String tableName;

  /// The current version of the table schema
  final int version;

  const SqlTable({required this.tableName, required this.version});
}
