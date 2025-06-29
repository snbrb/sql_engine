// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison

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
    final String query =
        includeDeleted
            ? 'SELECT * FROM Users'
            : 'SELECT * FROM Users WHERE deleted_at IS NULL';

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
    final String query =
        includeDeleted
            ? 'SELECT * FROM Users WHERE $condition'
            : 'SELECT * FROM Users WHERE ($condition) AND deleted_at IS NULL';

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
