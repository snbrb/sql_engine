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
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name TEXT NOT NULL
);
""",
    2: r"""CREATE TABLE user_mg (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  full_name TEXT NOT NULL,
  email TEXT
);
""",
  };

  @override
  List<String> get createIndexes => [];

  @override
  String get createTable => r"""CREATE TABLE user_mg (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  full_name TEXT NOT NULL,
  email TEXT
);
""";

  static List<SqlEngineMigration> get migrations => [
    const SqlEngineMigration(
      version: 2,
      up: r"""ALTER TABLE user_mg RENAME COLUMN name TO full_name;
ALTER TABLE user_mg ADD COLUMN email TEXT;""",
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
