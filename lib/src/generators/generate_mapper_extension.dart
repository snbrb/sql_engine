import '../../sql_engine.dart';
import '../utils/string_utils.dart';

String generateMapperExtension(String className, List<SqlColumn> columns) {
  final StringBuffer fromBuffer = StringBuffer();
  final StringBuffer toBuffer = StringBuffer();

  for (final SqlColumn col in columns) {
    final String name = col.name;
    final String dartKey = StringUtils.snakeToCamel(name);
    final String dartType = StringUtils.inferDartType(col);
    final bool nullable = col.nullable;

    // === FROM ROW ===
    if (dartType == 'bool') {
      final String read =
          nullable
              ? "row.containsKey('$name') ? row['$name'] == 1 : null"
              : "row['$name'] == 1";
      fromBuffer.writeln('      $dartKey: $read,');
      toBuffer.writeln(
        "      '$name': ${nullable ? '$dartKey == true ? 1 : null' : '$dartKey == true ? 1 : 0'},",
      );
      continue;
    }

    if (dartType == 'DateTime') {
      final String read =
          nullable
              ? "row.containsKey('$name') && row['$name'] != null ? DateTime.fromMillisecondsSinceEpoch(row['$name'] as int) : null"
              : "DateTime.fromMillisecondsSinceEpoch(row['$name'] as int)";
      final String write =
          nullable
              ? '$dartKey?.millisecondsSinceEpoch'
              : '$dartKey.millisecondsSinceEpoch';
      fromBuffer.writeln('      $dartKey: $read,');
      toBuffer.writeln("      '$name': $write,");
      continue;
    }

    if (dartType == 'double') {
      final String read =
          nullable
              ? "row.containsKey('$name') && row['$name'] != null ? (row['$name'] as num).toDouble() : null"
              : "(row['$name'] as num).toDouble()";
      final String write = nullable ? '$dartKey?' : dartKey;
      fromBuffer.writeln('      $dartKey: $read,');
      toBuffer.writeln("      '$name': $write,");
      continue;
    }

    if (dartType == 'List<int>') {
      final String read =
          nullable ? "row['$name'] as List<int>?" : "row['$name'] as List<int>";
      final String write = nullable ? dartKey : dartKey;

      fromBuffer.writeln('      $dartKey: $read,');
      toBuffer.writeln("      '$name': $write,");
      continue;
    }

    // Fallback: int, String, etc.
    final String read =
        nullable
            ? "row.containsKey('$name') ? row['$name'] as $dartType? : null"
            : "row['$name'] as $dartType";
    final String write = nullable ? dartKey : dartKey;
    fromBuffer.writeln('      $dartKey: $read,');
    toBuffer.writeln("      '$name': $write,");
  }

  return '''
extension ${className}Mapper on $className {
  static $className fromRow(Map<String, dynamic> row) {
    return $className(
${fromBuffer.toString()}    );
  }

  Map<String, Object?> toRow() {
    return {
${toBuffer.toString()}    };
  }
}
''';
}
