import '../annotations/sql_index.dart';

List<String> generateIndexStatements(
  String tableName,
  List<SqlIndex> indexes,
) =>
    indexes.map((SqlIndex index) {
      final String cols = index.columns.join(', ');
      return 'CREATE INDEX ${index.name} ON $tableName ($cols);';
    }).toList();
