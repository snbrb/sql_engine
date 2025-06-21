// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison

part of 'user.dart';

// **************************************************************************
// SqlEngineGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

class UserTable extends SqlEngineTable {
  const UserTable() : super(tableName: 'users');

  @override
  Map<int, String> get createTableHistory => {
    1: r"""CREATE TABLE users (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  name text NOT NULL,
  male boolean,
  created_at DATE,
  data blob
);
""",
  };

  @override
  List<Map<String, dynamic>> get initialSeedData => <Map<String, dynamic>>[
    {'name': 'Alice', 'male': false, 'created_at': 1717800000000, 'data': null},
    {'name': 'Bob', 'male': true, 'created_at': 1717900000000, 'data': null},
  ];

  @override
  List<String> get createIndexes => [
    r"""CREATE INDEX idx_user_name ON users (name);""",
  ];

  @override
  String get createTable => r"""CREATE TABLE users (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  name text NOT NULL,
  male boolean,
  created_at DATE,
  data blob
);
""";

  static List<SqlEngineMigration> get migrations => [];
}

extension UserMapper on User {
  static User fromRow(Map<String, dynamic> row) {
    return User(
      id: row['id'] as int,
      name: row['name'] as String,
      male: row.containsKey('male') ? row['male'] == 1 : null,
      createdAt:
          row.containsKey('created_at') && row['created_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int)
              : null,
      data: row['data'] as List<int>?,
    );
  }

  Map<String, Object?> toRow() {
    return {
      'id': id,
      'name': name,
      'male': male == true ? 1 : null,
      'created_at': createdAt?.millisecondsSinceEpoch,
      'data': data,
    };
  }
}

extension UserCrud on SqlEngineDatabase {
  // INSERT ------------------------------------------------------------------
  Future<void> insertUser(User entity) async {
    await runSql(
      'INSERT INTO users (id, name, male, created_at, data) VALUES (?, ?, ?, ?, ?)',
      positionalParams: <Object?>[
        entity.id,
        entity.name,
        entity.male,
        entity.createdAt?.millisecondsSinceEpoch,
        entity.data,
      ],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> deleteUserById(Object? id) async => runSql<int>(
    'DELETE FROM users WHERE id = ?',
    positionalParams: <Object?>[id],
  );

  Future<int> deleteUserWhere(String field, Object? value) async => runSql<int>(
    'DELETE FROM users WHERE $field = ?',
    positionalParams: <Object?>[value],
  );

  Future<int> flushUsers() async => runSql<int>('DELETE FROM users');

  // UPDATE ------------------------------------------------------------------
  Future<void> updateUser(User entity) async {
    await runSql(
      'UPDATE users SET name = ?, male = ?, created_at = ?, data = ? WHERE id = ?',
      positionalParams: <Object?>[
        entity.name,
        entity.male,
        entity.createdAt?.millisecondsSinceEpoch,
        entity.data,
        entity.id,
      ],
    );
  }

  // UPSERT ------------------------------------------------------------------
  Future<void> upsertUser(User entity) async {
    await runSql(
      'INSERT INTO users (id, name, male, created_at, data) VALUES (?, ?, ?, ?, ?) '
      'ON CONFLICT(id) DO UPDATE SET name = ?, male = ?, created_at = ?, data = ?',
      positionalParams: <Object?>[
        entity.id,
        entity.name,
        entity.male,
        entity.createdAt?.millisecondsSinceEpoch,
        entity.data,
        entity.name,
        entity.male,
        entity.createdAt?.millisecondsSinceEpoch,
        entity.data,
      ],
    );
  }

  // SELECT ------------------------------------------------------------------
  Future<List<User>> findAllUsers() async => runSql<List<User>>(
    'SELECT * FROM users',
    mapper: (rows) => rows.map(UserMapper.fromRow).toList(),
  );

  Future<List<User>> findUsersWhere(
    String condition,
    List<Object?> positionalParams,
  ) async {
    return runSql<List<User>>(
      'SELECT * FROM users WHERE $condition',
      positionalParams: positionalParams,
      mapper: (rows) => rows.map(UserMapper.fromRow).toList(),
    );
  }
}

class UserCrudHelpers {
  static Future<void> insert(
    SqlEngineDatabase db, {
    required int id,
    required String name,
    bool? male,
    DateTime? createdAt,
    List<int>? data,
  }) async {
    await db.insertUser(
      User(id: id, name: name, male: male, createdAt: createdAt, data: data),
    );
  }

  static Future<void> update(
    SqlEngineDatabase db, {
    required int id,
    required String name,
    bool? male,
    DateTime? createdAt,
    List<int>? data,
  }) async {
    await db.updateUser(
      User(id: id, name: name, male: male, createdAt: createdAt, data: data),
    );
  }

  static Future<void> upsert(
    SqlEngineDatabase db, {
    required int id,
    required String name,
    bool? male,
    DateTime? createdAt,
    List<int>? data,
  }) async {
    await db.upsertUser(
      User(id: id, name: name, male: male, createdAt: createdAt, data: data),
    );
  }

  static Future<void> deleteById(SqlEngineDatabase db, Object? id) async {
    await db.deleteUserById(id);
  }

  static Future<void> deleteIdWhere(SqlEngineDatabase db, Object? id) async {
    await db.deleteUserById(id);
  }

  static Future<void> deleteWhere(
    SqlEngineDatabase db,
    String field,
    Object? value,
  ) async {
    await db.deleteUserWhere(field, value);
  }

  static Future<List<User>> findAll(SqlEngineDatabase db) async {
    return await db.findAllUsers();
  }

  static Future<List<User>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams,
  ) async {
    return await db.findUsersWhere(condition, positionalParams);
  }

  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flushUsers();
  }
}
