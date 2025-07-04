// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison, unnecessary_cast, invalid_null_aware_operator

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
      positionalParams: <dynamic>[entity.id, entity.fullName, entity.email],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> deleteUserMgById(dynamic id) async => runSql<int>(
    'DELETE FROM user_mg WHERE id = ?',
    positionalParams: <dynamic>[id],
  );

  Future<int> deleteUserMgWhere(String field, dynamic value) async =>
      runSql<int>(
        'DELETE FROM user_mg WHERE $field = ?',
        positionalParams: <dynamic>[value],
      );

  Future<int> flushUserMgs() async => runSql<int>('DELETE FROM user_mg');

  // RESTORE ------------------------------------------------------------------
  Future<int> restoreUserMgById(dynamic id) async => runSql<int>(
    'UPDATE user_mg SET deleted_at = NULL WHERE id = ?',
    positionalParams: <dynamic>[id],
  );

  // UPDATE ------------------------------------------------------------------
  Future<void> updateUserMg(UserMg entity) async {
    await runSql(
      'UPDATE user_mg SET full_name = ?, email = ? WHERE id = ?',
      positionalParams: <dynamic>[entity.fullName, entity.email, entity.id],
    );
  }

  // UPSERT ------------------------------------------------------------------
  Future<void> upsertUserMg(UserMg entity) async {
    await runSql(
      'INSERT INTO user_mg (id, full_name, email) VALUES (?, ?, ?) '
      'ON CONFLICT(id) DO UPDATE SET full_name = ?, email = ?',
      positionalParams: <dynamic>[
        entity.id,
        entity.fullName,
        entity.email,
        entity.fullName,
        entity.email,
      ],
    );
  }

  // SELECT ------------------------------------------------------------------
  Future<List<UserMg>> findAllUserMgs({bool includeDeleted = false}) async {
    final String query = 'SELECT * FROM user_mg';

    return runSql<List<UserMg>>(
      query,
      mapper: (rows) => rows.map(UserMgMapper.fromRow).toList(),
    );
  }

  Future<List<UserMg>> findUserMgsWhere(
    String condition,
    List<dynamic> positionalParams, {
    bool includeDeleted = false,
  }) async {
    final String query = 'SELECT * FROM user_mg WHERE $condition';

    return runSql<List<UserMg>>(
      query,
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

  static Future<List<UserMg>> findAll(
    SqlEngineDatabase db, {
    bool includeDeleted = false,
  }) async {
    return await db.findAllUserMgs(includeDeleted: includeDeleted);
  }

  static Future<List<UserMg>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams, {
    bool includeDeleted = false,
  }) async {
    return await db.findUserMgsWhere(
      condition,
      positionalParams,
      includeDeleted: includeDeleted,
    );
  }

  static Future<void> restoreById(SqlEngineDatabase db, dynamic id) async {
    await db.runSql(
      'UPDATE user_mg SET deleted_at = NULL WHERE id = ?',
      positionalParams: <Object?>[id],
    );
  }

  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flushUserMgs();
  }
}

extension UserMgBinary on UserMg {
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
    // string full_name
    final List<int> _b1 = utf8.encode(this.fullName as String);
    buf.add(_i32(_b1.length));
    buf.add(_b1);
    // nullable email
    if (this.email != null) {
      buf.addByte(1); // string email
      final List<int> _b2 = utf8.encode(this.email as String);
      buf.add(_i32(_b2.length));
      buf.add(_b2);
    } else {
      buf.addByte(0);
    }

    return buf.takeBytes();
  }

  // ---- decode ------------------------------------------------------------
  static UserMg fromBytes(Uint8List input) {
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
    late String fullName;
    String? email;

    id = _readI64();
    final int _len1 = _readI32();
    fullName = utf8.decode(input.sublist(_ofs, _ofs + _len1));
    _ofs += _len1;
    if (_next() == 1) {
      final int _len2 = _readI32();
      email = utf8.decode(input.sublist(_ofs, _ofs + _len2));
      _ofs += _len2;
    }

    return UserMg(id: id, fullName: fullName, email: email);
  }
}
