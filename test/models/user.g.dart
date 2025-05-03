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
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name TEXT NOT NULL,
  male BOOLEAN,
  created_at DATETIME,
  data BLOB
);
""",
  };

  @override
  List<String> get createIndexes => [
    r"""CREATE INDEX idx_user_name ON users (name);""",
  ];

  @override
  String get createTable => r"""CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name TEXT NOT NULL,
  male BOOLEAN,
  created_at DATETIME,
  data BLOB
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
