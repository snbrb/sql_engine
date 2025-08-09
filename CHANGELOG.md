## [2.0.5] – 2025-08-09
### Updated

- dependencies are updated 

## [2.0.5] – 2025-07-05

### Added

* **Binary Serialization Helpers (`toBytes` / `fromBytes`)**  
  Every generated model now includes a zero‑allocation binary codec:

  ```dart
  final bytes = user.toBytes();          // → Uint8List
  final user2 = UserBinary.fromBytes(bytes);
  ```

  * Column order follows the latest `@SqlSchema`.
  * Little‑endian layout with compact variable‑length encoding for `String` and `BLOB`.
  * Nullable columns use a one‑byte presence flag (0 / 1).
  * Fully type‑safe – `DateTime` stored as `int64` milliseconds, `bool` as `0/1`.
  * Thorough test‑suite (`test/binary_codec_test.dart`) covers:
    * Round‑trip of all field types
    * Nullable vs non‑nullable columns
    * Edge‑cases: empty strings/blobs, max/min numeric values, very long payloads.

  #### Example
  ```dart
  final order = Order(
    id: 9,
    customerId: 42,
    orderDate: DateTime.utc(2025, 7, 1, 18),
    total: 123.45,
  );

  final data = order.toBytes();          // serialize
  final copy = OrderBinary.fromBytes(data);

  assert(copy.total == 123.45);          // 
  ```



## [2.0.4] – 2025-06-29

###  Added

- **Soft Delete Support**
  - You can now enable soft deletion using `@SqlTable(softDelete: true)`.
    ```dart
    @SqlTable(tableName: 'users', version: 1, softDelete: true)
    class User { ... }
    ```
  - When enabled:
    - All `deleteById()` operations update `deleted_at = CURRENT_TIMESTAMP` instead of removing rows.
    - All `findAll()` and `findWhere()` queries automatically **exclude soft-deleted rows** by default.
    - Use `includeDeleted: true` to include them.
    - A new helper `restoreById()` is generated to restore soft-deleted rows.
  - Supports:
    - Nullable `deleted_at` column (added automatically if missing)
    - Standard SQLite timestamp
    - Reversible deletes via `restoreById()`

  #### Example
  ```dart
  await UserCrudHelpers.deleteById(db, 5); // sets deleted_at
  await UserCrudHelpers.findAll(db); // excludes deleted
  await UserCrudHelpers.findAll(db, includeDeleted: true); // includes deleted
  await UserCrudHelpers.restoreById(db, 5); // restores record
  ```

  > Fully tested under `test/soft_delete_test.dart` — including restore and manual inspection via raw SQL.



## [2.0.3] - 2025-06-12

###  Added

- **Initial Seed Data Support**
  - `@SqlSchema` now accepts a `seedData` field:
    ```dart
    @SqlSchema(
      version: 1,
      columns: [...],
      seedData: [
        {'name': 'Alice', 'male': false},
        {'name': 'Bob', 'male': true},
      ],
    )
    ```
  - Seed rows are **automatically inserted** into the table **on first creation only**.
  - Supports:
    - `DateTime` (use `millisecondsSinceEpoch`)
    - `bool` (stored as `0/1`)
    - `null` values
  - Automatically skipped if the table already exists.
  - Available during `db.open()` lifecycle — no extra config required.

### Example

```dart
@SqlSchema(
  version: 1,
  columns: [...],
  seedData: [
    {
      'name': 'Ada',
      'male': true,
      'created_at': DateTime(2024, 1, 1).millisecondsSinceEpoch,
    }
  ],
)
```

## [2.0.2] - 2025-06-10
- updated documentation for models


## [2.0.1] - 2025-06-08

### ✨ Added
- **Strongly-Typed CRUD Code Generation**  
  New generator methods now create full CRUD extensions for each model/table:
  - `insert<Entity>()`
  - `update<Entity>()`
  - `upsert<Entity>()`
  - `delete<Entity>ById()`
  - `delete<Entity>Where()`
  - `flush<Entity>s()`
  - `findAll<Entity>s()`
  - `find<Entity>sWhere()`

  These methods are emitted as `extension <Entity>Crud on SqlEngineDatabase`, with support for:
  - Named parameter helpers (`<Entity>CrudHelpers`)
  - Automatic conversion of `DateTime` → `millisecondsSinceEpoch`
  - Nullable field safety
  - Strongly-typed model mapping with `<Entity>Mapper.fromRow`

  #### Example
  ```dart
  await User.insert(
    db,
    id: 1,
    name: 'Jane Smith',
    male: true,
    createdAt: DateTime.now(),
  );

  final users = await User.findWhere(db, 'name = ?', 'Jane Smith');


## [2.0.0] - 2025-06-01

### ⚠️ Breaking Changes
- `SqlColumn.type` is now required to be a `SqlType` enum instead of a string. This improves type safety and autocompletion.
  - **Before:**
    ```dart
    SqlColumn(name: 'id', type: 'INTEGER')
    ```
  - **After:**
    ```dart
    SqlColumn(name: 'id', type: SqlType.integer)
    ```

- Code generators have been updated to map `SqlType` to proper SQL keywords in `CREATE TABLE`, `ALTER TABLE`, and index creation.


## [1.0.6] - 2025-05-04

### Added
- `enableLog` parameter to `SqlEngineDatabase` constructor. This allows consumers of the package to **disable or control logging**, instead of relying on a global compile-time flag.
  ```dart
  final db = SqlEngineDatabase(enableLog: false);


## [1.0.5] – 2025‑05‑03

### Fixed
* **Mapper code‑gen**
  * Removed illegal trailing `?` in `toRow()` for nullable fields (e.g. now emits  
    `'locationLat': locationLat,` instead of `'locationLat': locationLat?,`).
  * Null‑safe write for `DateTime` (`createdAt?.millisecondsSinceEpoch`) and for `bool`
    (`male == true ? 1 : null`).

### Added
* **`@SqlIndex` annotation**
  * Define one or more indexes per table.  
    ```dart
    @SqlIndex(name: 'idx_user_email', columns: ['email'])
    ```
  * Generator now outputs a `createIndexes` list inside each `*Table` class.
  * `_onCreate()` automatically executes all `CREATE INDEX` statements after tables
    are created.



### Migration
No breaking API changes. Re‑run `build_runner` to regenerate code and
indexes will be created automatically the next time the database is
initialized.


## [1.0.4] - 2025-05-03

### Added
- Introduced `@SqlIndex` annotation for defining named indexes on tables.
- Generator now reads and embeds indexes as part of the generated table class.
- Database applies all defined indexes automatically during `open()` on initial creation.
- Added `createIndexes` override in `SqlEngineTable` to allow per-table index registration.
- Added test support:
  - Verify index creation using `PRAGMA index_list`.
  - Verify index usage via `EXPLAIN QUERY PLAN`.

### Tests
* New tests verify:
  * Index is present (`PRAGMA index_list`)
  * Index is used (`EXPLAIN QUERY PLAN … USING INDEX`)
  
### Example usage

```dart
@SqlTable(tableName: 'users', version: 1)
@SqlIndex(name: 'idx_user_name', columns: ['name'])
class User { ... }
```

## [1.0.3] 
- Fixed analysis error.
- Added license