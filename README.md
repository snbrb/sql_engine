# 🧠 sql_engine

*A thin yet powerful SQLite layer for Dart & Flutter.*

![sql_engine banner](assets/banner01.png)


---

## ✨ Key features

- **Raw SQL freedom** – run any statement you like (`JOIN`, `UPSERT`, FTS5…).
- **Schema annotations** – use `@SqlTable` + `@SqlSchema` to generate  
  `CREATE TABLE` scripts *and* versioned migrations automatically.
- **Two setup styles**
    1. *Low‑level* `SqlEngineDatabase` – explicit registration.
    2. *Drift‑style* `@SqlDatabase` – one annotation, everything wired for you.
- **Model mapping** – `fromRow` / `toRow` helpers are generated for each table.
- **No mirrors, no hidden allocations** – works on Flutter, server, CLI, Wasm.

---

## 📦 Install

```yaml
dependencies:
  sql_engine: ^1.0.0
  sqlite3: ^2.3.0    # native engine
  build_runner: ^2.4.6
  source_gen: ^1.5.0
```

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## 🛠 Quick start

### 1. Define a model

```dart
import 'package:sql_engine/sql_engine.dart';

part 'user.g.dart';

@SqlTable(tableName: 'users', version: 2)

@SqlSchema(
  version: 1,
  columns: [
    SqlColumn(name: 'id',  type: 'INTEGER', primaryKey: true, autoincrement: true, nullable: false),
    SqlColumn(name: 'name', type: 'TEXT',    nullable: false),
  ],
)

@SqlSchema(
  version: 2,
  columns: [
    SqlColumn(name: 'id',  type: 'INTEGER', primaryKey: true, autoincrement: true, nullable: false),
    SqlColumn(name: 'full_name', type: 'TEXT', nullable: false, renamedFrom: 'name'),
    SqlColumn(name: 'email', type: 'TEXT', nullable: true),
  ],
)
class User {
  final int? id;
  final String fullName;
  final String? email;

  User({this.id, required this.fullName, this.email});
}
```

Run the generator. You'll get user.g.dart with:
- UserTable (DDL + migrations)
- UserMapper.fromRow / toRow

### 2A. Manual database (explicit)

```dart
final db = SqlEngineDatabase();

db.registerTable([
  const UserTable(),       // generated class
]);

await db.open();           // uses :memory: by default
```

### 2B. Annotated app database (automatic)

```dart
import 'package:sql_engine/sql_engine.dart';
import 'user.dart';

part 'app_database.g.dart';

@SqlDatabase(
  version: 2,
  models: [User],
)
class AppDatabase {}
```

```dart
final db = $AppDatabase(); // generated subclass
await db.open();
```

## 🔄 CRUD cheat‑sheet

### Insert

```dart
await db.runSql(
  'INSERT INTO users (full_name, email) VALUES (?, ?)',
  positionalParams: ['Ada Lovelace', 'ada@history.dev'],
);
```

### Select + mapper

```dart
final users = await db.runSql<List<User>>(
  'SELECT * FROM users WHERE email LIKE ?',
  positionalParams: ['%@history.dev'],
  mapper: (rows) => rows.map(UserMapper.fromRow).toList(),
);
```

### Update

```dart
await db.runSql(
  'UPDATE users SET email = ? WHERE id = ?',
  positionalParams: ['ada@computing.io', 1],
);
```

### Upsert

```dart
await db.runSql(
  '''
  INSERT INTO users (id, full_name)
  VALUES (?, ?)
  ON CONFLICT(id) DO UPDATE SET full_name = excluded.full_name
  ''',
  positionalParams: [1, 'A. Lovelace‑Updated'],
);
```

### Join

```dart
final rows = await db.runSql('''
  SELECT u.full_name, o.total
  FROM users u
  JOIN orders o ON u.id = o.customer_id
  WHERE o.total > ?
''', positionalParams: [100]);
```

## 🗄️ Migrations

Add a new `@SqlSchema(version: N+1, …)` block to your model, bump the `@SqlTable(version: N+1)`, run the generator again.

The tool emits idempotent ALTER TABLE statements (rename, add, etc.) and stores them inside `UserTable.migrations`.

When you open the database with a higher version value, the engine:

1. Reads `PRAGMA user_version`.
2. Runs all missing migrations in order.
3. Updates `user_version` to the target.

## 📚 Advanced topics

- FTS5 virtual tables (`CREATE VIRTUAL TABLE … USING fts5`)
- WAL vs DELETE journal modes (`JournalMode.wal`)
- Transactions:

```dart
await db.transaction(() async {
  await db.runSql('INSERT …');
  await db.runSql('UPDATE …');
});
```

- Row ↔ JSON helpers (see example/).

## 🔍 Related terms

SQL, SQLite, FTS5, UPSERT, JOIN, WAL, migration, schema, Dart ORM.

## 🤝 Contributing & roadmap

We welcome issues and PRs!
Planned features:

- CLI schema diff viewer
- Code‑first migrations
- Migration rollback helper

See CONTRIBUTING.md for details.

## 💬 Support

- File an issue on the GitHub tracker
- Any direct suggestions are welcome bilalrabbi@gmail.com