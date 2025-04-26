///sql database annotation
class SqlDatabase {
  /// The schema version of the whole app DB
  final int version;

  /// List of model types to include
  final List<Type> models;

  const SqlDatabase({required this.version, required this.models});
}
