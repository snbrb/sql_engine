// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison, unnecessary_cast, invalid_null_aware_operator

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
  deleted_at DATE,
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
  deleted_at DATE,
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
              ? DateTime.fromMillisecondsSinceEpoch(
                row['created_at'] is int
                    ? row['created_at'] as int
                    : int.tryParse('${row['created_at']}') ?? 0,
              )
              : null,
      deletedAt:
          row.containsKey('deleted_at') && row['deleted_at'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                row['deleted_at'] is int
                    ? row['deleted_at'] as int
                    : int.tryParse('${row['deleted_at']}') ?? 0,
              )
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
      'deleted_at': deletedAt?.millisecondsSinceEpoch,
      'data': data,
    };
  }
}

extension UserCrud on SqlEngineDatabase {
  // INSERT ------------------------------------------------------------------
  Future<void> insertUser(User entity) async {
    await runSql(
      'INSERT INTO users (id, name, male, created_at, deleted_at, data) VALUES (?, ?, ?, ?, ?, ?)',
      positionalParams: <dynamic>[
        entity.id,
        entity.name,
        entity.male,
        entity.createdAt?.millisecondsSinceEpoch,
        entity.deletedAt?.millisecondsSinceEpoch,
        entity.data,
      ],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> deleteUserById(dynamic id) async => runSql<int>(
    'UPDATE users SET deleted_at = CURRENT_TIMESTAMP WHERE id = ?',
    positionalParams: <dynamic>[id],
  );

  Future<int> deleteUserWhere(String field, dynamic value) async => runSql<int>(
    'DELETE FROM users WHERE $field = ?',
    positionalParams: <dynamic>[value],
  );

  Future<int> flushUsers() async => runSql<int>('DELETE FROM users');

  // RESTORE ------------------------------------------------------------------
  Future<int> restoreUserById(dynamic id) async => runSql<int>(
    'UPDATE users SET deleted_at = NULL WHERE id = ?',
    positionalParams: <dynamic>[id],
  );

  // UPDATE ------------------------------------------------------------------
  Future<void> updateUser(User entity) async {
    await runSql(
      'UPDATE users SET name = ?, male = ?, created_at = ?, deleted_at = ?, data = ? WHERE id = ?',
      positionalParams: <dynamic>[
        entity.name,
        entity.male,
        entity.createdAt?.millisecondsSinceEpoch,
        entity.deletedAt?.millisecondsSinceEpoch,
        entity.data,
        entity.id,
      ],
    );
  }

  // UPSERT ------------------------------------------------------------------
  Future<void> upsertUser(User entity) async {
    await runSql(
      'INSERT INTO users (id, name, male, created_at, deleted_at, data) VALUES (?, ?, ?, ?, ?, ?) '
      'ON CONFLICT(id) DO UPDATE SET name = ?, male = ?, created_at = ?, deleted_at = ?, data = ?',
      positionalParams: <dynamic>[
        entity.id,
        entity.name,
        entity.male,
        entity.createdAt?.millisecondsSinceEpoch,
        entity.deletedAt?.millisecondsSinceEpoch,
        entity.data,
        entity.name,
        entity.male,
        entity.createdAt?.millisecondsSinceEpoch,
        entity.deletedAt?.millisecondsSinceEpoch,
        entity.data,
      ],
    );
  }

  // SELECT ------------------------------------------------------------------
  Future<List<User>> findAllUsers({bool includeDeleted = false}) async {
    final String query =
        includeDeleted
            ? 'SELECT * FROM users'
            : 'SELECT * FROM users WHERE deleted_at IS NULL';

    return runSql<List<User>>(
      query,
      mapper: (rows) => rows.map(UserMapper.fromRow).toList(),
    );
  }

  Future<List<User>> findUsersWhere(
    String condition,
    List<dynamic> positionalParams, {
    bool includeDeleted = false,
  }) async {
    final String query =
        includeDeleted
            ? 'SELECT * FROM users WHERE $condition'
            : 'SELECT * FROM users WHERE ($condition) AND deleted_at IS NULL';

    return runSql<List<User>>(
      query,
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
    DateTime? deletedAt,
    List<int>? data,
  }) async {
    await db.insertUser(
      User(
        id: id,
        name: name,
        male: male,
        createdAt: createdAt,
        deletedAt: deletedAt,
        data: data,
      ),
    );
  }

  static Future<void> update(
    SqlEngineDatabase db, {
    required int id,
    required String name,
    bool? male,
    DateTime? createdAt,
    DateTime? deletedAt,
    List<int>? data,
  }) async {
    await db.updateUser(
      User(
        id: id,
        name: name,
        male: male,
        createdAt: createdAt,
        deletedAt: deletedAt,
        data: data,
      ),
    );
  }

  static Future<void> upsert(
    SqlEngineDatabase db, {
    required int id,
    required String name,
    bool? male,
    DateTime? createdAt,
    DateTime? deletedAt,
    List<int>? data,
  }) async {
    await db.upsertUser(
      User(
        id: id,
        name: name,
        male: male,
        createdAt: createdAt,
        deletedAt: deletedAt,
        data: data,
      ),
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

  static Future<List<User>> findAll(
    SqlEngineDatabase db, {
    bool includeDeleted = false,
  }) async {
    return await db.findAllUsers(includeDeleted: includeDeleted);
  }

  static Future<List<User>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams, {
    bool includeDeleted = false,
  }) async {
    return await db.findUsersWhere(
      condition,
      positionalParams,
      includeDeleted: includeDeleted,
    );
  }

  static Future<void> restoreById(SqlEngineDatabase db, dynamic id) async {
    await db.runSql(
      'UPDATE users SET deleted_at = NULL WHERE id = ?',
      positionalParams: <Object?>[id],
    );
  }

  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flushUsers();
  }
}

extension UserBinary on User {
  // ---- helpers -----------------------------------------------------------
  static Uint8List _i32(int v) {
    final b = ByteData(4)..setInt32(0, v, Endian.little);
    return b.buffer.asUint8List();
  }

  static Uint8List _i64(int v) {
    final b = ByteData(8)..setInt64(0, v, Endian.little);
    return b.buffer.asUint8List();
  }

  static Uint8List _f64(double v) {
    final b = ByteData(8)..setFloat64(0, v, Endian.little);
    return b.buffer.asUint8List();
  }

  // ---- encode ------------------------------------------------------------
  Uint8List toBytes() {
    final buf = BytesBuilder();
    // int id
    buf.add(_i64(this.id as int));
    // string name
    final List<int> _b1 = utf8.encode(this.name as String);
    buf.add(_i32(_b1.length));
    buf.add(_b1);
    // nullable male
    if (this.male != null) {
      buf.addByte(1); // bool male
      buf.addByte(this.male == true ? 1 : 0);
    } else {
      buf.addByte(0);
    }
    // nullable created_at
    if (this.createdAt != null) {
      buf.addByte(1); // DateTime created_at  → int64
      buf.add(_i64((this.createdAt as DateTime).millisecondsSinceEpoch));
    } else {
      buf.addByte(0);
    }
    // nullable deleted_at
    if (this.deletedAt != null) {
      buf.addByte(1); // DateTime deleted_at  → int64
      buf.add(_i64((this.deletedAt as DateTime).millisecondsSinceEpoch));
    } else {
      buf.addByte(0);
    }
    // nullable data
    if (this.data != null) {
      buf.addByte(1); // blob data
      buf.add(_i32((this.data as List<int>).length));
      buf.add(this.data as List<int>);
    } else {
      buf.addByte(0);
    }

    return buf.takeBytes();
  }

  // ---- decode ------------------------------------------------------------
  static User fromBytes(Uint8List input) {
    final bv = input.buffer.asByteData();
    int _ofs = 0;
    int _next() => input[_ofs++]; // 1 byte shortcut
    int _readI32() {
      final v = bv.getInt32(_ofs, Endian.little);
      _ofs += 4;
      return v;
    }

    int _readI64() {
      final v = bv.getInt64(_ofs, Endian.little);
      _ofs += 8;
      return v;
    }

    double _readF64() {
      final v = bv.getFloat64(_ofs, Endian.little);
      _ofs += 8;
      return v;
    }

    late int id;
    late String name;
    bool? male;
    DateTime? createdAt;
    DateTime? deletedAt;
    List<int>? data;

    id = _readI64();
    final int _len1 = _readI32();
    name = utf8.decode(input.sublist(_ofs, _ofs + _len1));
    _ofs += _len1;
    if (_next() == 1) {
      male = _next() == 1;
    }
    if (_next() == 1) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(_readI64());
    }
    if (_next() == 1) {
      deletedAt = DateTime.fromMillisecondsSinceEpoch(_readI64());
    }
    if (_next() == 1) {
      final int _len5 = _readI32();
      data = input.sublist(_ofs, _ofs + _len5);
      _ofs += _len5;
    }

    return User(
      id: id,
      name: name,
      male: male,
      createdAt: createdAt,
      deletedAt: deletedAt,
      data: data,
    );
  }
}
