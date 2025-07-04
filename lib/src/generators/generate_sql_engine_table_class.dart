import '../../sql_engine.dart';
import 'extract_sql_create_table_query.dart';
import 'generate_binary_serializer.dart';
import 'generate_crud_methods.dart';
import 'generate_mapper_extension.dart';
import 'generate_migration_code.dart';
import 'generate_model_crud_helpers.dart';
import 'generate_seed_data.dart';

String generateSqlEngineTableClass({
  required String originalClassName,
  required String tableName,
  required String createTableSql,
  required List<SqlEngineMigration> migrations,
  required List<SqlColumn> columns,
  required List<SqlSchema> schemas,
  List<String> createIndexes = const <String>[],
  bool softDelete = false,
}) {
  //
  final String migrationCode = generateMigrationCode(migrations);
  // generate mapper function for each table
  final String mapperExtension = generateMapperExtension(
    originalClassName,
    columns,
  );
  final String crudHelpers = generateModelCrudHelpers(
    className: originalClassName,
    tableName: tableName,
    columns: columns,
  );

  final String crudMethods = generateCrudMethods(
    originalClassName: originalClassName,
    tableName: tableName,
    columns: columns,
    softDelete: softDelete,
  );

  //create indexSql for indexes
  final String indexSql = createIndexes
      .map((String e) => 'r"""$e"""')
      .join(',\n    ');

  final String historyEntries =
      schemas.map((SqlSchema s) {
        final String sql = extractSqlCreateTableQuery(tableName, s);
        return '${s.version}: r"""$sql""",';
      }).join();

  final SqlSchema latestSchema = schemas.last;
  final String initialSeedData = generateSeedData(latestSchema.seedData);
  final String binaryExt = generateBinarySerializer(originalClassName, columns);

  return '''
// GENERATED CODE - DO NOT MODIFY BY HAND

class ${originalClassName}Table extends SqlEngineTable {
  const ${originalClassName}Table() : super(tableName: '$tableName');
  
    @override
  Map<int, String> get createTableHistory => {
    $historyEntries
  };

  @override
  List<Map<String, dynamic>> get initialSeedData => $initialSeedData;

  @override
  List<String> get createIndexes => [
    $indexSql
  ];


  @override
  String get createTable => r"""$createTableSql""";

  static List<SqlEngineMigration> get migrations => [
    $migrationCode
  ];
}
$mapperExtension
$crudMethods
$crudHelpers
$binaryExt
''';
}
