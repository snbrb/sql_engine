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
