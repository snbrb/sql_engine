import 'package:sql_engine/sql_engine.dart';

part 'user.g.dart';

@SqlTable(tableName: 'users', version: 1)
@SqlSchema(
  version: 1,
  columns: <SqlColumn>[
    SqlColumn(
      name: 'id',
      type: 'INTEGER',
      primaryKey: true,
      autoincrement: true,
      nullable: false,
    ),
    SqlColumn(name: 'name', type: 'TEXT', nullable: false),
    SqlColumn(name: 'male', type: 'BOOLEAN', nullable: true), // stored as 0/1
    SqlColumn(name: 'created_at', type: 'DATETIME', nullable: true),
    SqlColumn(name: 'data', type: 'BLOB', nullable: true), // optional blob
  ],
)
class User {
  final int? id;
  final String name;
  final bool? male;
  final DateTime? createdAt;
  final List<int>? data;

  User({required this.name, this.id, this.male, this.createdAt, this.data});
}

// import 'package:sql_engine/sql_engine.dart';
//
// part 'user.g.dart';
//
// @SqlTable(tableName: 'users', version: 3)
// @SqlSchema(
//   version: 1,
//   columns: <SqlColumn>[
//     SqlColumn(
//       name: 'id',
//       type: 'INTEGER',
//       primaryKey: true,
//       autoincrement: true,
//       nullable: false,
//       renamedFrom: null,
//     ),
//     SqlColumn(name: 'name', type: 'TEXT', nullable: false),
//     SqlColumn(name: 'email', type: 'TEXT', unique: true, nullable: false),
//     SqlColumn(name: 'is_active', type: 'INTEGER', defaultValue: 1),
//   ],
// )
// @SqlSchema(
//   version: 2,
//   columns: <SqlColumn>[
//     SqlColumn(
//       name: 'id',
//       type: 'INTEGER',
//       primaryKey: true,
//       autoincrement: true,
//       nullable: false,
//     ),
//     SqlColumn(name: 'name', type: 'TEXT', nullable: false),
//     SqlColumn(name: 'email', type: 'TEXT', unique: true, nullable: false),
//     SqlColumn(name: 'is_active', type: 'INTEGER', defaultValue: 1),
//     SqlColumn(name: 'created_at', type: 'TEXT', nullable: false),
//   ],
// )
// @SqlSchema(
//   version: 3,
//   columns: <SqlColumn>[
//     SqlColumn(
//       name: 'id',
//       type: 'INTEGER',
//       primaryKey: true,
//       autoincrement: true,
//       nullable: false,
//     ),
//     SqlColumn(
//       name: 'full_name',
//       type: 'TEXT',
//       nullable: false,
//       renamedFrom: 'name', // 💡 Add this
//     ), // renamed from name -> full_name
//     SqlColumn(name: 'email', type: 'TEXT', unique: true, nullable: false),
//     SqlColumn(name: 'is_active', type: 'INTEGER', defaultValue: 1),
//     SqlColumn(name: 'created_at', type: 'TEXT', nullable: false),
//     SqlColumn(name: 'age', type: 'INTEGER'),
//     SqlColumn(name: 'balance', type: 'REAL', defaultValue: 0.0),
//     SqlColumn(name: 'bio', type: 'TEXT'),
//   ],
// )
// class User {
//   final int? id;
//   final String fullName;
//   final String email;
//   final int? isActive;
//   final String createdAt;
//   final int? age;
//   final double? balance;
//   final String? bio;
//
//   User({
//     required this.fullName,
//     required this.email,
//     required this.createdAt,
//     this.id,
//     this.isActive,
//     this.age,
//     this.balance,
//     this.bio,
//   });
// }
