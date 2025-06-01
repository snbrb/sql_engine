import '../enums/sql_type.dart';

class SqlColumn {
  final String name;
  final SqlType type;
  final bool primaryKey;
  final bool autoincrement;
  final bool unique;
  final bool nullable;
  final dynamic defaultValue;
  final String? references;
  final String? referenceColumn;
  final String? renamedFrom;

  const SqlColumn({
    required this.name,
    required this.type, // allow both SqlType and legacy string
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
