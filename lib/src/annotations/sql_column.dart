/// Definition of a SQL column with its properties
class SqlColumn {
  /// The name of the column
  final String name;

  /// The data type of the column (if not specified, will be inferred from the field type)
  final String? type;

  /// Whether this column is a primary key
  final bool primaryKey;

  /// Whether this column auto-increments
  final bool autoincrement;

  /// Whether this column must have unique values
  final bool unique;

  /// Whether this column can contain null values
  final bool nullable;

  /// Default value for this column
  final dynamic defaultValue;

  /// Reference to another table (foreign key)
  final String? references;

  /// Column in the referenced table
  final String? referenceColumn;

  /// If this column was renamed from a previous column name
  final String? renamedFrom;

  const SqlColumn({
    required this.name,
    this.type,
    this.primaryKey = false,
    this.autoincrement = false,
    this.unique = false,
    this.nullable = true,
    this.defaultValue,
    this.references,
    this.referenceColumn,
    this.renamedFrom,
  });
}
