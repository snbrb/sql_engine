## [1.0.4] - 2025-05-03

### Added
- Introduced `@SqlIndex` annotation for defining named indexes on tables.
- Generator now reads and embeds indexes as part of the generated table class.
- Database applies all defined indexes automatically during `open()` on initial creation.
- Added `createIndexes` override in `SqlEngineTable` to allow per-table index registration.
- Added test support:
  - Verify index creation using `PRAGMA index_list`.
  - Verify index usage via `EXPLAIN QUERY PLAN`.

### Example usage

```dart
@SqlTable(tableName: 'users', version: 1)
@SqlIndex(name: 'idx_user_name', columns: ['name'])
class User { ... }
