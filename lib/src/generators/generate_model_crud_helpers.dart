import '../../sql_engine.dart';
import '../utils/string_utils.dart';

String generateModelCrudHelpers({
  required String className,
  required String tableName,
  required List<SqlColumn> columns,
}) {
  final StringBuffer methodBuffer = StringBuffer();

  final List<SqlColumn> nonNullCols =
      columns.where((SqlColumn c) => !c.nullable).toList();
  final List<SqlColumn> nullableCols =
      columns.where((SqlColumn c) => c.nullable).toList();

  final String namedRequired = nonNullCols
      .map((SqlColumn c) {
        final String name = StringUtils.snakeToCamel(c.name);
        final String type = StringUtils.inferDartType(c);
        return 'required $type $name';
      })
      .join(',\n    ');

  final String namedOptional = nullableCols
      .map((SqlColumn c) {
        final String name = StringUtils.snakeToCamel(c.name);
        final String type = StringUtils.inferDartType(c);
        return '$type? $name';
      })
      .join(',\n    ');

  final String argList = <String>[
    ...nonNullCols.map(
      (SqlColumn c) =>
          '${StringUtils.snakeToCamel(c.name)}: ${StringUtils.snakeToCamel(c.name)}',
    ),
    ...nullableCols.map(
      (SqlColumn c) =>
          '${StringUtils.snakeToCamel(c.name)}: ${StringUtils.snakeToCamel(c.name)}',
    ),
  ].join(',\n      ');

  methodBuffer.writeln('''
  static Future<void> insert(SqlEngineDatabase db, {
    $namedRequired${nullableCols.isNotEmpty ? ',' : ''}
    ${namedOptional.isNotEmpty ? namedOptional : ''}
  }) async {
    await db.insert$className($className(
      $argList
    ));
  }

  static Future<void> update(SqlEngineDatabase db, {
    $namedRequired${nullableCols.isNotEmpty ? ',' : ''}
    ${namedOptional.isNotEmpty ? namedOptional : ''}
  }) async {
    await db.update$className($className(
      $argList
    ));
  }

  static Future<void> upsert(SqlEngineDatabase db, {
    $namedRequired${nullableCols.isNotEmpty ? ',' : ''}
    ${namedOptional.isNotEmpty ? namedOptional : ''}
  }) async {
    await db.upsert$className($className(
      $argList
    ));
  }

  static Future<void> deleteById(SqlEngineDatabase db, Object? id) async {
    await db.delete${className}ById(id);
  }

  static Future<void> deleteIdWhere(SqlEngineDatabase db, Object? id) async {
    await db.delete${className}ById(id);
  }

  static Future<void> deleteWhere(SqlEngineDatabase db, String field, Object? value) async {
    await db.delete${className}Where(field, value);
  }

  static Future<List<$className>> findAll(SqlEngineDatabase db, {bool includeDeleted = false}) async {
    return await db.findAll${className}s(includeDeleted: includeDeleted);
  }

  static Future<List<$className>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams, {
    bool includeDeleted = false,
  }) async {
    return await db.find${className}sWhere(condition, positionalParams, includeDeleted: includeDeleted);
  }
  
  static Future<void> restoreById(SqlEngineDatabase db, dynamic id) async {
    await db.runSql(
      'UPDATE $tableName SET deleted_at = NULL WHERE id = ?',
      positionalParams: <Object?>[id],
    );
  }


  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flush${className}s();
  }
''');

  return '''
class ${className}CrudHelpers {
$methodBuffer
}
''';
}
