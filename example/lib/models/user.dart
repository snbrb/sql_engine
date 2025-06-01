import 'package:sql_engine/sql_engine.dart';

part 'user.g.dart';

@SqlTable(tableName: 'users', version: 1)
@SqlSchema(
  version: 1,
  columns: <SqlColumn>[
    SqlColumn(
      name: 'id',
      type: SqlType.integer,
      primaryKey: true,
      autoincrement: true,
      nullable: false,
    ),
    SqlColumn(name: 'name', type: SqlType.text, nullable: false),
    SqlColumn(
      name: 'male',
      type: SqlType.boolean,
      nullable: true,
    ), // stored as 0/1
    SqlColumn(name: 'created_at', type: SqlType.date, nullable: true),
    SqlColumn(
      name: 'data',
      type: SqlType.blob,
      nullable: true,
    ), // optional blob
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
//       type: SqlType.integer,
//       primaryKey: true,
//       autoincrement: true,
//       nullable: false,
//       renamedFrom: null,
//     ),
//     SqlColumn(name: 'name', type: SqlType.text, nullable: false),
//     SqlColumn(name: 'email', type: SqlType.text, unique: true, nullable: false),
//     SqlColumn(name: 'is_active', type: SqlType.integer, defaultValue: 1),
//   ],
// )
// @SqlSchema(
//   version: 2,
//   columns: <SqlColumn>[
//     SqlColumn(
//       name: 'id',
//       type: SqlType.integer,
//       primaryKey: true,
//       autoincrement: true,
//       nullable: false,
//     ),
//     SqlColumn(name: 'name', type: SqlType.text, nullable: false),
//     SqlColumn(name: 'email', type: SqlType.text, unique: true, nullable: false),
//     SqlColumn(name: 'is_active', type: SqlType.integer, defaultValue: 1),
//     SqlColumn(name: 'created_at', type: SqlType.text, nullable: false),
//   ],
// )
// @SqlSchema(
//   version: 3,
//   columns: <SqlColumn>[
//     SqlColumn(
//       name: 'id',
//       type: SqlType.integer,
//       primaryKey: true,
//       autoincrement: true,
//       nullable: false,
//     ),
//     SqlColumn(
//       name: 'full_name',
//       type: SqlType.text,
//       nullable: false,
//       renamedFrom: 'name', // 💡 Add this
//     ), // renamed from name -> full_name
//     SqlColumn(name: 'email', type: SqlType.text, unique: true, nullable: false),
//     SqlColumn(name: 'is_active', type: SqlType.integer, defaultValue: 1),
//     SqlColumn(name: 'created_at', type: SqlType.text, nullable: false),
//     SqlColumn(name: 'age', type: SqlType.integer),
//     SqlColumn(name: 'balance', type: SqlType.real, defaultValue: 0.0),
//     SqlColumn(name: 'bio', type: SqlType.text),
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
