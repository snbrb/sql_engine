import 'package:sql_engine/sql_engine.dart';

part 'user_mg.g.dart';

/// This table starts at v1 with only `id` and `name`,
/// then at v2 we
///   • add `email`  (NULL‑able)
///   • rename `name` → `full_name`
@SqlTable(tableName: 'user_mg', version: 2)
/// ── Version 1 ────────────────────────────────
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
  ],
)
/// ── Version 2 ────────────────────────────────
@SqlSchema(
  version: 2,
  columns: <SqlColumn>[
    // ➊ same PK
    SqlColumn(
      name: 'id',
      type: 'INTEGER',
      primaryKey: true,
      autoincrement: true,
      nullable: false,
    ),
    // ➋ renamed column
    SqlColumn(
      name: 'full_name',
      type: 'TEXT',
      nullable: false,
      renamedFrom: 'name',
    ),
    // ➌ brand‑new column
    SqlColumn(name: 'email', type: 'TEXT', nullable: true),
  ],
)
class UserMg extends UserMgTable {
  final int? id;
  final String fullName; // note field follows latest schema
  final String? email;

  UserMg({required this.fullName, this.id, this.email});

  String get create => createTable;
}
