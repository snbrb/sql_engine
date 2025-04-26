/// Represents a database migration with up and down operations
class SqlEngineMigration {
  final int version;
  final String up;
  final String down;
  final String description;

  const SqlEngineMigration({
    required this.version,
    required this.up,
    required this.down,
    required this.description,
  });
}
