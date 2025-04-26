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
    final String type = (col.type ?? '').toLowerCase();

    switch (type) {
      case 'integer':
        return 'int';
      case 'real':
        return 'double';
      case 'boolean':
        return 'bool';
      case 'datetime':
        return 'DateTime';
      case 'blob':
        return 'List<int>';
      case 'text':
      default:
        return 'String';
    }
  }
}
