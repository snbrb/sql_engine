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

### Tests
* New tests verify:
  * Index is present (`PRAGMA index_list`)
  * Index is used (`EXPLAIN QUERY PLAN … USING INDEX`)

### Migration
No breaking API changes. Re‑run `build_runner` to regenerate code and
indexes will be created automatically the next time the database is
initialized.
