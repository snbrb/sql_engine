// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison

part of 'user_mg.dart';

// **************************************************************************
// SqlEngineGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

class UserMgTable extends SqlEngineTable {
  const UserMgTable() : super(tableName: 'user_mg');

  @override
  Map<int, String> get createTableHistory => {
    1: r"""CREATE TABLE user_mg (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  name text NOT NULL
);
""",
    2: r"""CREATE TABLE user_mg (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  full_name text NOT NULL,
  email text
);
""",
  };

  @override
  List<Map<String, dynamic>> get initialSeedData => <Map<String, dynamic>>[];

  @override
  List<String> get createIndexes => [];

  @override
  String get createTable => r"""CREATE TABLE user_mg (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  full_name text NOT NULL,
  email text
);
""";

  static List<SqlEngineMigration> get migrations => [
    const SqlEngineMigration(
      version: 2,
      up: r"""ALTER TABLE user_mg RENAME COLUMN name TO full_name;
ALTER TABLE user_mg ADD COLUMN email text;""",
      down: r"""-- Down migration for version 2 not implemented.""",
      description: 'Upgrade user_mg to version 2',
    ),
  ];
}

extension UserMgMapper on UserMg {
  static UserMg fromRow(Map<String, dynamic> row) {
    return UserMg(
      id: row['id'] as int,
      fullName: row['full_name'] as String,
      email: row.containsKey('email') ? row['email'] as String? : null,
    );
  }

  Map<String, Object?> toRow() {
    return {'id': id, 'full_name': fullName, 'email': email};
  }
}

extension UserMgCrud on SqlEngineDatabase {
  // INSERT ------------------------------------------------------------------
  Future<void> insertUserMg(UserMg entity) async {
    await runSql(
      'INSERT INTO user_mg (id, full_name, email) VALUES (?, ?, ?)',
      positionalParams: <Object?>[entity.id, entity.fullName, entity.email],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> deleteUserMgById(Object? id) async => runSql<int>(
    'DELETE FROM user_mg WHERE id = ?',
    positionalParams: <Object?>[id],
  );

  Future<int> deleteUserMgWhere(String field, Object? value) async =>
      runSql<int>(
        'DELETE FROM user_mg WHERE $field = ?',
        positionalParams: <Object?>[value],
      );

  Future<int> flushUserMgs() async => runSql<int>('DELETE FROM user_mg');

  // UPDATE ------------------------------------------------------------------
  Future<void> updateUserMg(UserMg entity) async {
    await runSql(
      'UPDATE user_mg SET full_name = ?, email = ? WHERE id = ?',
      positionalParams: <Object?>[entity.fullName, entity.email, entity.id],
    );
  }

  // UPSERT ------------------------------------------------------------------
  Future<void> upsertUserMg(UserMg entity) async {
    await runSql(
      'INSERT INTO user_mg (id, full_name, email) VALUES (?, ?, ?) '
      'ON CONFLICT(id) DO UPDATE SET full_name = ?, email = ?',
      positionalParams: <Object?>[
        entity.id,
        entity.fullName,
        entity.email,
        entity.fullName,
        entity.email,
      ],
    );
  }

  // SELECT ------------------------------------------------------------------
  Future<List<UserMg>> findAllUserMgs() async => runSql<List<UserMg>>(
    'SELECT * FROM user_mg',
    mapper: (rows) => rows.map(UserMgMapper.fromRow).toList(),
  );

  Future<List<UserMg>> findUserMgsWhere(
    String condition,
    List<Object?> positionalParams,
  ) async {
    return runSql<List<UserMg>>(
      'SELECT * FROM user_mg WHERE $condition',
      positionalParams: positionalParams,
      mapper: (rows) => rows.map(UserMgMapper.fromRow).toList(),
    );
  }
}

class UserMgCrudHelpers {
  static Future<void> insert(
    SqlEngineDatabase db, {
    required int id,
    required String fullName,
    String? email,
  }) async {
    await db.insertUserMg(UserMg(id: id, fullName: fullName, email: email));
  }

  static Future<void> update(
    SqlEngineDatabase db, {
    required int id,
    required String fullName,
    String? email,
  }) async {
    await db.updateUserMg(UserMg(id: id, fullName: fullName, email: email));
  }

  static Future<void> upsert(
    SqlEngineDatabase db, {
    required int id,
    required String fullName,
    String? email,
  }) async {
    await db.upsertUserMg(UserMg(id: id, fullName: fullName, email: email));
  }

  static Future<void> deleteById(SqlEngineDatabase db, Object? id) async {
    await db.deleteUserMgById(id);
  }

  static Future<void> deleteIdWhere(SqlEngineDatabase db, Object? id) async {
    await db.deleteUserMgById(id);
  }

  static Future<void> deleteWhere(
    SqlEngineDatabase db,
    String field,
    Object? value,
  ) async {
    await db.deleteUserMgWhere(field, value);
  }

  static Future<List<UserMg>> findAll(SqlEngineDatabase db) async {
    return await db.findAllUserMgs();
  }

  static Future<List<UserMg>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams,
  ) async {
    return await db.findUserMgsWhere(condition, positionalParams);
  }

  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flushUserMgs();
  }
}
