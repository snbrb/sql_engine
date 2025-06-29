// ─────────────────────────────────────────────────────────────────────────────
// CRUD-method generator
// ─────────────────────────────────────────────────────────────────────────────
import '../../sql_engine.dart';
import '../utils/string_utils.dart';

String generateCrudMethods({
  required String originalClassName,
  required String tableName,
  required List<SqlColumn> columns,
  required bool softDelete,
}) {
  final String pkName =
      columns
          .firstWhere(
            (SqlColumn c) => c.primaryKey,
            orElse: () => columns.first,
          )
          .name;

  final String csvColumnNames = columns.map((SqlColumn c) => c.name).join(', ');
  final String csvPlaceholders = List<dynamic>.filled(
    columns.length,
    '?',
  ).join(', ');

  final String positionalFromEntity = columns
      .map((SqlColumn c) {
        final String field = 'entity.${StringUtils.snakeToCamel(c.name)}';
        return c.type == SqlType.date
            ? (c.nullable
                ? '$field?.millisecondsSinceEpoch'
                : '$field.millisecondsSinceEpoch')
            : field;
      })
      .join(',\n        ');

  final List<SqlColumn> nonPk =
      columns.where((SqlColumn c) => !c.primaryKey).toList();

  final String setClause = nonPk
      .map((SqlColumn c) => '${c.name} = ?')
      .join(', ');

  final String positionalUpdate = <String>[
    for (final SqlColumn c in nonPk)
      () {
        final String field = 'entity.${StringUtils.snakeToCamel(c.name)}';
        return c.type == SqlType.date
            ? (c.nullable
                ? '$field?.millisecondsSinceEpoch'
                : '$field.millisecondsSinceEpoch')
            : field;
      }(),
    'entity.${StringUtils.snakeToCamel(pkName)}',
  ].join(',\n        ');

  return '''
extension ${originalClassName}Crud on SqlEngineDatabase {

  // INSERT ------------------------------------------------------------------
  Future<void> insert$originalClassName($originalClassName entity) async {
    await runSql(
      'INSERT INTO $tableName ($csvColumnNames) VALUES ($csvPlaceholders)',
      positionalParams: <dynamic>[
        $positionalFromEntity
      ],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> delete${originalClassName}ById(dynamic id) async =>
      runSql<int>(
        ${softDelete ? "'UPDATE $tableName SET deleted_at = CURRENT_TIMESTAMP WHERE $pkName = ?'" : "'DELETE FROM $tableName WHERE $pkName = ?'"},
        positionalParams: <dynamic>[id],
      );

  Future<int> delete${originalClassName}Where(String field, dynamic value) async =>
      runSql<int>(
        'DELETE FROM $tableName WHERE \$field = ?',
        positionalParams: <dynamic>[value],
      );

  Future<int> flush${originalClassName}s() async =>
      runSql<int>('DELETE FROM $tableName');

  // RESTORE ------------------------------------------------------------------
  Future<int> restore${originalClassName}ById(dynamic id) async =>
      runSql<int>(
        'UPDATE $tableName SET deleted_at = NULL WHERE $pkName = ?',
        positionalParams: <dynamic>[id],
      );

  // UPDATE ------------------------------------------------------------------
  Future<void> update$originalClassName($originalClassName entity) async {
    await runSql(
      'UPDATE $tableName SET $setClause WHERE $pkName = ?',
      positionalParams: <dynamic>[
        $positionalUpdate
      ],
    );
  }

  // UPSERT ------------------------------------------------------------------
  Future<void> upsert$originalClassName($originalClassName entity) async {
    await runSql(
      'INSERT INTO $tableName ($csvColumnNames) VALUES ($csvPlaceholders) '
      'ON CONFLICT($pkName) DO UPDATE SET $setClause',
      positionalParams: <dynamic>[
        $positionalFromEntity,
        ${nonPk.map((SqlColumn c) {
    final String field = 'entity.${StringUtils.snakeToCamel(c.name)}';
    return c.type == SqlType.date ? '$field?.millisecondsSinceEpoch' : field;
  }).join(',\n        ')}
      ],
    );
  }

  // SELECT ------------------------------------------------------------------
  Future<List<$originalClassName>> findAll${originalClassName}s({bool includeDeleted = false}) async {
    final String query = includeDeleted
      ? 'SELECT * FROM $tableName'
      : 'SELECT * FROM $tableName WHERE deleted_at IS NULL';

    return runSql<List<$originalClassName>>(
      query,
      mapper: (rows) => rows.map(${originalClassName}Mapper.fromRow).toList(),
    );
  }

  Future<List<$originalClassName>> find${originalClassName}sWhere(
    String condition,
    List<dynamic> positionalParams, {
    bool includeDeleted = false,
  }) async {
    final String query = includeDeleted
      ? 'SELECT * FROM $tableName WHERE \$condition'
      : 'SELECT * FROM $tableName WHERE (\$condition) AND deleted_at IS NULL';

    return runSql<List<$originalClassName>>(
      query,
      positionalParams: positionalParams,
      mapper: (rows) => rows.map(${originalClassName}Mapper.fromRow).toList(),
    );
  }

}
''';
}
