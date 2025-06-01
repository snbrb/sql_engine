enum SqlType {
  integer,
  real,
  text,
  blob,
  boolean,
  date;

  /// Returns the SQL string representation (e.g. SqlType.integer, SqlType.text)
  String get sqlName {
    switch (this) {
      case integer:
        return SqlType.integer.name;
      case real:
        return SqlType.real.name;
      case text:
        return SqlType.text.name;
      case blob:
        return SqlType.blob.name;
      case boolean:
        return SqlType.boolean.name;
      case date:
        return 'DATE';
    }
  }

  /// Parses a SqlType from its enum name (e.g. SqlType.integer)
  static SqlType fromName(String name) => SqlType.values.firstWhere(
    (SqlType e) => e.name == name,
    orElse: () => throw ArgumentError('Invalid SqlType name: $name'),
  );

  /// Parses a SqlType from its accessor (e.g. 'SqlType.integer')
  static SqlType fromAccessor(String accessor) {
    final List<String> parts = accessor.split('.');
    return fromName(parts.last);
  }
}
