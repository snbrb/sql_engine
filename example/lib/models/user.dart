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
  seedData: <Map<String, dynamic>>[
    <String, dynamic>{
      'name': 'Alice',
      'male': false,
      'created_at': 1717800000000, // millisecondsSinceEpoch
      'data': null,
    },
    <String, dynamic>{
      'name': 'Bob',
      'male': true,
      'created_at': 1717900000000,
      'data': null,
    },
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
