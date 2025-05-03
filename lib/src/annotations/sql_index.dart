/// define index on table
class SqlIndex {
  /// name for index
  final String name;

  /// columns for index
  final List<String> columns;

  /// constructor
  const SqlIndex({required this.name, required this.columns});
}
