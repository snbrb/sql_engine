abstract class SqlEngineTable {
  /// table name
  final String tableName;

  /// Full history of CREATE TABLE scripts – must include *every* version.
  Map<int, String> get createTableHistory => <int, String>{};

  List<String> get createIndexes => <String>[];

  /// Latest version’s script (handy for ad‑hoc use).
  String get createTable => createTableHistory[createTableHistory.keys.last]!;

  /// Utility – pick the script for a specific version, or throw.
  String createSqlFor(int version) =>
      createTableHistory[version] ??
      (throw ArgumentError('No CREATE TABLE for $tableName version $version'));

  //String get createTable => '';

  //constructor
  const SqlEngineTable({required this.tableName});
}
