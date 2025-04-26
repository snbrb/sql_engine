import '../../sql_engine.dart';
import 'extract_sql_create_table_query.dart';
import 'generate_mapper_extension.dart';
import 'generate_migration_code.dart';

String generateSqlEngineTableClass({
  required String originalClassName,
  required String tableName,
  required String createTableSql,
  required List<SqlEngineMigration> migrations,
  required List<SqlColumn> columns,
  required List<SqlSchema> schemas,
}) {
  //
  final String migrationCode = generateMigrationCode(migrations);
  // generate mapper function for each table
  final String mapperExtension = generateMapperExtension(
    originalClassName,
    columns,
  );

  final String historyEntries =
      schemas.map((SqlSchema s) {
        final String sql = extractSqlCreateTableQuery(tableName, s);
        return '${s.version}: r"""$sql""",';
      }).join();

  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND

class ${originalClassName}Table extends SqlEngineTable {
  const ${originalClassName}Table() : super(tableName: '$tableName');
  
    @override
  Map<int, String> get createTableHistory => {
    $historyEntries
  };


  @override
  String get createTable => r"""$createTableSql""";

  static List<SqlEngineMigration> get migrations => [
    $migrationCode
  ];
}
$mapperExtension
''';
}
