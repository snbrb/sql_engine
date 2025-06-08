// ─────────────────────────────────────────────────────────────────────────────
// CRUD-method generator
// ─────────────────────────────────────────────────────────────────────────────
import '../../sql_engine.dart';
import '../utils/string_utils.dart';

/// Generates a `SqlEngineDatabase` extension with strongly-typed
/// CRUD helpers for a single model/table.
String generateCrudMethods({
  required String originalClassName,
  required String tableName,
  required List<SqlColumn> columns,
}) {
  final String pkName =
      columns.firstWhere((c) => c.primaryKey, orElse: () => columns.first).name;

  // SQL insert clause
  final String csvColumnNames = columns.map((c) => c.name).join(', ');
  final String csvPlaceholders = List.filled(columns.length, '?').join(', ');

  // INSERT positional values
  final String positionalFromEntity = columns
      .map((SqlColumn c) {
        final String dartField = 'entity.${StringUtils.snakeToCamel(c.name)}';
        return c.type == SqlType.date
            ? '$dartField?.millisecondsSinceEpoch'
            : dartField;
      })
      .join(',\n        ');

  // UPDATE clause
  final List<SqlColumn> nonPk = columns.where((c) => !c.primaryKey).toList();
  final String setClause = nonPk.map((c) => '${c.name} = ?').join(', ');
  final String positionalUpdate = <String>[
    for (final SqlColumn c in nonPk)
      () {
        final String dartField = 'entity.${StringUtils.snakeToCamel(c.name)}';
        return c.type == SqlType.date
            ? '$dartField?.millisecondsSinceEpoch'
            : dartField;
      }(),
    'entity.${StringUtils.snakeToCamel(pkName)}',
  ].join(',\n        ');

  return '''
extension ${originalClassName}Crud on SqlEngineDatabase {

  // INSERT ------------------------------------------------------------------
  Future<void> insert$originalClassName($originalClassName entity) async {
    await runSql(
      'INSERT INTO $tableName ($csvColumnNames) VALUES ($csvPlaceholders)',
      positionalParams: <Object?>[
        $positionalFromEntity
      ],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> delete${originalClassName}ById(Object? id) async =>
      runSql<int>(
        'DELETE FROM $tableName WHERE $pkName = ?',
        positionalParams: <Object?>[id],
      );

  Future<int> delete${originalClassName}Where(String field, Object? value) async =>
      runSql<int>(
        'DELETE FROM $tableName WHERE \$field = ?',
        positionalParams: <Object?>[value],
      );

  Future<int> flush${originalClassName}s() async =>
      runSql<int>('DELETE FROM $tableName');

  // UPDATE ------------------------------------------------------------------
  Future<void> update$originalClassName($originalClassName entity) async {
    await runSql(
      'UPDATE $tableName SET $setClause WHERE $pkName = ?',
      positionalParams: <Object?>[
        $positionalUpdate
      ],
    );
  }

 // UPSERT ------------------------------------------------------------------
Future<void> upsert$originalClassName($originalClassName entity) async {
  await runSql(
    'INSERT INTO $tableName ($csvColumnNames) VALUES ($csvPlaceholders) '
    'ON CONFLICT($pkName) DO UPDATE SET $setClause',
    positionalParams: <Object?>[
      $positionalFromEntity,
      ${nonPk.map((SqlColumn c) {
    final String field = 'entity.${StringUtils.snakeToCamel(c.name)}';
    return c.type == SqlType.date ? '$field?.millisecondsSinceEpoch' : field;
  }).join(',\n      ')}
    ],
  );
}


  // SELECT ------------------------------------------------------------------
  Future<List<$originalClassName>> findAll${originalClassName}s() async =>
      runSql<List<$originalClassName>>(
        'SELECT * FROM $tableName',
        mapper: (rows) => rows.map(${originalClassName}Mapper.fromRow).toList(),
      );

Future<List<$originalClassName>> find${originalClassName}sWhere(
    String condition, List<Object?> positionalParams) async {
  return runSql<List<$originalClassName>>(
    'SELECT * FROM $tableName WHERE \$condition',
    positionalParams: positionalParams,
    mapper: (rows) => rows.map(${originalClassName}Mapper.fromRow).toList(),
  );
}

}
''';
}
