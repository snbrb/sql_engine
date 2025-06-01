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