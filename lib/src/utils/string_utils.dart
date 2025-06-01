import '../../sql_engine.dart';

class StringUtils {
  static String snakeToCamel(String input) {
    final List<String> parts = input.split('_');
    return parts.first +
        parts
            .skip(1)
            .map((String p) => p[0].toUpperCase() + p.substring(1))
            .join();
  }

  static String inferDartType(SqlColumn col) {
    switch (col.type) {
      case SqlType.integer:
        return 'int';
      case SqlType.real:
        return 'double';
      case SqlType.boolean:
        return 'bool';
      case SqlType.date:
        return 'DateTime';
      case SqlType.blob:
        return 'List<int>';
      case SqlType.text:
        return 'String';
    }
  }
}
