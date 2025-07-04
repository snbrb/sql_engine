// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison, unnecessary_cast, invalid_null_aware_operator

part of 'new_user.dart';

// **************************************************************************
// SqlEngineGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

class NewUserTable extends SqlEngineTable {
  const NewUserTable() : super(tableName: 'Users');

  @override
  Map<int, String> get createTableHistory => {
    1: r"""CREATE TABLE Users (
  uid text PRIMARY KEY NOT NULL,
  displayName text NOT NULL,
  profilePhotoUrl text,
  locationLat real,
  locationLng real,
  voipToken text,
  platform text,
  firebaseToken text,
  lastUpdated integer
);
""",
  };

  @override
  List<Map<String, dynamic>> get initialSeedData => <Map<String, dynamic>>[];

  @override
  List<String> get createIndexes => [];

  @override
  String get createTable => r"""CREATE TABLE Users (
  uid text PRIMARY KEY NOT NULL,
  displayName text NOT NULL,
  profilePhotoUrl text,
  locationLat real,
  locationLng real,
  voipToken text,
  platform text,
  firebaseToken text,
  lastUpdated integer
);
""";

  static List<SqlEngineMigration> get migrations => [];
}

extension NewUserMapper on NewUser {
  static NewUser fromRow(Map<String, dynamic> row) {
    return NewUser(
      uid: row['uid'] as String,
      displayName: row['displayName'] as String,
      profilePhotoUrl:
          row.containsKey('profilePhotoUrl')
              ? row['profilePhotoUrl'] as String?
              : null,
      locationLat:
          row.containsKey('locationLat') && row['locationLat'] != null
              ? (row['locationLat'] as num).toDouble()
              : null,
      locationLng:
          row.containsKey('locationLng') && row['locationLng'] != null
              ? (row['locationLng'] as num).toDouble()
              : null,
      voipToken:
          row.containsKey('voipToken') ? row['voipToken'] as String? : null,
      platform: row.containsKey('platform') ? row['platform'] as String? : null,
      firebaseToken:
          row.containsKey('firebaseToken')
              ? row['firebaseToken'] as String?
              : null,
      lastUpdated:
          row.containsKey('lastUpdated') ? row['lastUpdated'] as int? : null,
    );
  }

  Map<String, Object?> toRow() {
    return {
      'uid': uid,
      'displayName': displayName,
      'profilePhotoUrl': profilePhotoUrl,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'voipToken': voipToken,
      'platform': platform,
      'firebaseToken': firebaseToken,
      'lastUpdated': lastUpdated,
    };
  }
}

extension NewUserCrud on SqlEngineDatabase {
  // INSERT ------------------------------------------------------------------
  Future<void> insertNewUser(NewUser entity) async {
    await runSql(
      'INSERT INTO Users (uid, displayName, profilePhotoUrl, locationLat, locationLng, voipToken, platform, firebaseToken, lastUpdated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      positionalParams: <dynamic>[
        entity.uid,
        entity.displayName,
        entity.profilePhotoUrl,
        entity.locationLat,
        entity.locationLng,
        entity.voipToken,
        entity.platform,
        entity.firebaseToken,
        entity.lastUpdated,
      ],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> deleteNewUserById(dynamic id) async => runSql<int>(
    'DELETE FROM Users WHERE uid = ?',
    positionalParams: <dynamic>[id],
  );

  Future<int> deleteNewUserWhere(String field, dynamic value) async =>
      runSql<int>(
        'DELETE FROM Users WHERE $field = ?',
        positionalParams: <dynamic>[value],
      );

  Future<int> flushNewUsers() async => runSql<int>('DELETE FROM Users');

  // RESTORE ------------------------------------------------------------------
  Future<int> restoreNewUserById(dynamic id) async => runSql<int>(
    'UPDATE Users SET deleted_at = NULL WHERE uid = ?',
    positionalParams: <dynamic>[id],
  );

  // UPDATE ------------------------------------------------------------------
  Future<void> updateNewUser(NewUser entity) async {
    await runSql(
      'UPDATE Users SET displayName = ?, profilePhotoUrl = ?, locationLat = ?, locationLng = ?, voipToken = ?, platform = ?, firebaseToken = ?, lastUpdated = ? WHERE uid = ?',
      positionalParams: <dynamic>[
        entity.displayName,
        entity.profilePhotoUrl,
        entity.locationLat,
        entity.locationLng,
        entity.voipToken,
        entity.platform,
        entity.firebaseToken,
        entity.lastUpdated,
        entity.uid,
      ],
    );
  }

  // UPSERT ------------------------------------------------------------------
  Future<void> upsertNewUser(NewUser entity) async {
    await runSql(
      'INSERT INTO Users (uid, displayName, profilePhotoUrl, locationLat, locationLng, voipToken, platform, firebaseToken, lastUpdated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) '
      'ON CONFLICT(uid) DO UPDATE SET displayName = ?, profilePhotoUrl = ?, locationLat = ?, locationLng = ?, voipToken = ?, platform = ?, firebaseToken = ?, lastUpdated = ?',
      positionalParams: <dynamic>[
        entity.uid,
        entity.displayName,
        entity.profilePhotoUrl,
        entity.locationLat,
        entity.locationLng,
        entity.voipToken,
        entity.platform,
        entity.firebaseToken,
        entity.lastUpdated,
        entity.displayName,
        entity.profilePhotoUrl,
        entity.locationLat,
        entity.locationLng,
        entity.voipToken,
        entity.platform,
        entity.firebaseToken,
        entity.lastUpdated,
      ],
    );
  }

  // SELECT ------------------------------------------------------------------
  Future<List<NewUser>> findAllNewUsers({bool includeDeleted = false}) async {
    final String query = 'SELECT * FROM Users';

    return runSql<List<NewUser>>(
      query,
      mapper: (rows) => rows.map(NewUserMapper.fromRow).toList(),
    );
  }

  Future<List<NewUser>> findNewUsersWhere(
    String condition,
    List<dynamic> positionalParams, {
    bool includeDeleted = false,
  }) async {
    final String query = 'SELECT * FROM Users WHERE $condition';

    return runSql<List<NewUser>>(
      query,
      positionalParams: positionalParams,
      mapper: (rows) => rows.map(NewUserMapper.fromRow).toList(),
    );
  }
}

class NewUserCrudHelpers {
  static Future<void> insert(
    SqlEngineDatabase db, {
    required String uid,
    required String displayName,
    String? profilePhotoUrl,
    double? locationLat,
    double? locationLng,
    String? voipToken,
    String? platform,
    String? firebaseToken,
    int? lastUpdated,
  }) async {
    await db.insertNewUser(
      NewUser(
        uid: uid,
        displayName: displayName,
        profilePhotoUrl: profilePhotoUrl,
        locationLat: locationLat,
        locationLng: locationLng,
        voipToken: voipToken,
        platform: platform,
        firebaseToken: firebaseToken,
        lastUpdated: lastUpdated,
      ),
    );
  }

  static Future<void> update(
    SqlEngineDatabase db, {
    required String uid,
    required String displayName,
    String? profilePhotoUrl,
    double? locationLat,
    double? locationLng,
    String? voipToken,
    String? platform,
    String? firebaseToken,
    int? lastUpdated,
  }) async {
    await db.updateNewUser(
      NewUser(
        uid: uid,
        displayName: displayName,
        profilePhotoUrl: profilePhotoUrl,
        locationLat: locationLat,
        locationLng: locationLng,
        voipToken: voipToken,
        platform: platform,
        firebaseToken: firebaseToken,
        lastUpdated: lastUpdated,
      ),
    );
  }

  static Future<void> upsert(
    SqlEngineDatabase db, {
    required String uid,
    required String displayName,
    String? profilePhotoUrl,
    double? locationLat,
    double? locationLng,
    String? voipToken,
    String? platform,
    String? firebaseToken,
    int? lastUpdated,
  }) async {
    await db.upsertNewUser(
      NewUser(
        uid: uid,
        displayName: displayName,
        profilePhotoUrl: profilePhotoUrl,
        locationLat: locationLat,
        locationLng: locationLng,
        voipToken: voipToken,
        platform: platform,
        firebaseToken: firebaseToken,
        lastUpdated: lastUpdated,
      ),
    );
  }

  static Future<void> deleteById(SqlEngineDatabase db, Object? id) async {
    await db.deleteNewUserById(id);
  }

  static Future<void> deleteIdWhere(SqlEngineDatabase db, Object? id) async {
    await db.deleteNewUserById(id);
  }

  static Future<void> deleteWhere(
    SqlEngineDatabase db,
    String field,
    Object? value,
  ) async {
    await db.deleteNewUserWhere(field, value);
  }

  static Future<List<NewUser>> findAll(
    SqlEngineDatabase db, {
    bool includeDeleted = false,
  }) async {
    return await db.findAllNewUsers(includeDeleted: includeDeleted);
  }

  static Future<List<NewUser>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams, {
    bool includeDeleted = false,
  }) async {
    return await db.findNewUsersWhere(
      condition,
      positionalParams,
      includeDeleted: includeDeleted,
    );
  }

  static Future<void> restoreById(SqlEngineDatabase db, dynamic id) async {
    await db.runSql(
      'UPDATE Users SET deleted_at = NULL WHERE id = ?',
      positionalParams: <Object?>[id],
    );
  }

  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flushNewUsers();
  }
}

extension NewUserBinary on NewUser {
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
    // string uid
    final List<int> _b0 = utf8.encode(this.uid as String);
    buf.add(_i32(_b0.length));
    buf.add(_b0);
    // string displayName
    final List<int> _b1 = utf8.encode(this.displayName as String);
    buf.add(_i32(_b1.length));
    buf.add(_b1);
    // nullable profilePhotoUrl
    if (this.profilePhotoUrl != null) {
      buf.addByte(1); // string profilePhotoUrl
      final List<int> _b2 = utf8.encode(this.profilePhotoUrl as String);
      buf.add(_i32(_b2.length));
      buf.add(_b2);
    } else {
      buf.addByte(0);
    }
    // nullable locationLat
    if (this.locationLat != null) {
      buf.addByte(1); // double locationLat
      buf.add(_f64(this.locationLat as double));
    } else {
      buf.addByte(0);
    }
    // nullable locationLng
    if (this.locationLng != null) {
      buf.addByte(1); // double locationLng
      buf.add(_f64(this.locationLng as double));
    } else {
      buf.addByte(0);
    }
    // nullable voipToken
    if (this.voipToken != null) {
      buf.addByte(1); // string voipToken
      final List<int> _b5 = utf8.encode(this.voipToken as String);
      buf.add(_i32(_b5.length));
      buf.add(_b5);
    } else {
      buf.addByte(0);
    }
    // nullable platform
    if (this.platform != null) {
      buf.addByte(1); // string platform
      final List<int> _b6 = utf8.encode(this.platform as String);
      buf.add(_i32(_b6.length));
      buf.add(_b6);
    } else {
      buf.addByte(0);
    }
    // nullable firebaseToken
    if (this.firebaseToken != null) {
      buf.addByte(1); // string firebaseToken
      final List<int> _b7 = utf8.encode(this.firebaseToken as String);
      buf.add(_i32(_b7.length));
      buf.add(_b7);
    } else {
      buf.addByte(0);
    }
    // nullable lastUpdated
    if (this.lastUpdated != null) {
      buf.addByte(1); // int lastUpdated
      buf.add(_i64(this.lastUpdated as int));
    } else {
      buf.addByte(0);
    }

    return buf.takeBytes();
  }

  // ---- decode ------------------------------------------------------------
  static NewUser fromBytes(Uint8List input) {
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

    late String uid;
    late String displayName;
    String? profilePhotoUrl;
    double? locationLat;
    double? locationLng;
    String? voipToken;
    String? platform;
    String? firebaseToken;
    int? lastUpdated;

    final int _len0 = _readI32();
    uid = utf8.decode(input.sublist(_ofs, _ofs + _len0));
    _ofs += _len0;
    final int _len1 = _readI32();
    displayName = utf8.decode(input.sublist(_ofs, _ofs + _len1));
    _ofs += _len1;
    if (_next() == 1) {
      final int _len2 = _readI32();
      profilePhotoUrl = utf8.decode(input.sublist(_ofs, _ofs + _len2));
      _ofs += _len2;
    }
    if (_next() == 1) {
      locationLat = _readF64();
    }
    if (_next() == 1) {
      locationLng = _readF64();
    }
    if (_next() == 1) {
      final int _len5 = _readI32();
      voipToken = utf8.decode(input.sublist(_ofs, _ofs + _len5));
      _ofs += _len5;
    }
    if (_next() == 1) {
      final int _len6 = _readI32();
      platform = utf8.decode(input.sublist(_ofs, _ofs + _len6));
      _ofs += _len6;
    }
    if (_next() == 1) {
      final int _len7 = _readI32();
      firebaseToken = utf8.decode(input.sublist(_ofs, _ofs + _len7));
      _ofs += _len7;
    }
    if (_next() == 1) {
      lastUpdated = _readI64();
    }

    return NewUser(
      uid: uid,
      displayName: displayName,
      profilePhotoUrl: profilePhotoUrl,
      locationLat: locationLat,
      locationLng: locationLng,
      voipToken: voipToken,
      platform: platform,
      firebaseToken: firebaseToken,
      lastUpdated: lastUpdated,
    );
  }
}
