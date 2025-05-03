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
@SqlIndex(name: 'idx_user_name', columns: <String>['name'])
class User {
  final int? id;
  final String name;
  final bool? male;
  final DateTime? createdAt;
  final List<int>? data;

  User({required this.name, this.id, this.male, this.createdAt, this.data});
}
