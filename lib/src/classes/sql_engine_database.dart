//import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:sqlite3/common.dart';

import '../config.dart';
import '../drivers/sqlite_driver_factory.dart';
import '../enums/journal_mode.dart';
import '../exceptions.dart';
import '../utils/db_utils.dart';
import './sql_engine_migration.dart';
import 'sql_engine_table.dart';

final SqliteDriverFactory _driverFactory = getDriverFactory();

class SqlEngineDatabase {
  // db path
  final String dbPath;
  // current version of database
  final int version;
  // List of migration
  final List<SqlEngineMigration> migrations;
  // journnal mode
  final JournalMode mode;
  CommonDatabase? _db;
  // all tables in my project or the one i want to add
  final List<SqlEngineTable> _tableObjects = <SqlEngineTable>[];
  // constructor
  SqlEngineDatabase({
    this.dbPath = ':memory:',
    this.version = 1,
    this.migrations = const <SqlEngineMigration>[],
    this.mode = JournalMode.delete,
  });

  /// Register tables with the database
  void registerTable(List<dynamic> tables) {
    for (final dynamic table in tables) {
      if (table is SqlEngineTable) {
        // The traditional approach with SqlEngineTable instances
        // _tables[table.tableName] = table.createTable;
        _tableObjects.add(table);
        continue;
      }
      throw SqlEngineException(
        'Invalid table registration. Expected SqlEngineTable or Type, got ${table.runtimeType}.',
      );
    }
  }

  CommonDatabase get database {
    if (_db == null) {
      throw StateError('Database not opened. Call open() first.');
    }
    return _db!;
  }

  Future<void> open() async {
    if (_db != null) {
      return;
    }

    final bool isFreshDb = isNewDatabase(dbPath);

    _db = await _driverFactory.open(dbPath);

    // sqlite3.open(dbPath);
    // if no database file exists on a path
    if (isFreshDb) {
      await _onCreate(); //  Ensure `_migrations` table exists!
    } else {
      // PRAGMA user_version is a command that's part of SQLite's PRAGMA statements,
      // which are special commands used to modify the operation of the SQLite library or
      // to query internal (non-table) data.
      final Row row = database.select('PRAGMA user_version').first;
      final int currentVersion = row['user_version'] as int;
      if (enableLog) {
        debugPrint(' Current DB Version: $currentVersion (Target: $version)');
      }
      //e.g user create db object with version 2 and current version is 1
      if (currentVersion < version) {
        await _applyMigrations(currentVersion, version);
      }
    }
  }

  Future<void> _onCreate() async {
    if (enableLog) {
      debugPrint(' Running _onCreate() - Creating migrations table');
    }
    database.execute('PRAGMA journal_mode = $mode');
    // Ensure the `_migrations` table exists
    database.execute('''
    CREATE TABLE IF NOT EXISTS _migrations (
      version INTEGER NOT NULL PRIMARY KEY,
      description TEXT NOT NULL,
      applied_at INTEGER NOT NULL,
      rolled_back_at INTEGER
    );
  ''');

    // Create tables from registered models
    // for (final MapEntry<String, String> entry in _tables.entries) {
    //   database.execute(entry.value);
    // }

    for (final SqlEngineTable tbl in _tableObjects) {
      final String ddl = tbl.createSqlFor(version); // ← use target version
      database.execute(ddl);
    }

    // Set the database version to match the provided `version`
    database.execute('PRAGMA user_version = $version;');

    // Insert an initial migration record
    final ResultSet migrationCheck = database.select(
      'SELECT COUNT(*) as count FROM _migrations',
    );
    if (migrationCheck.first['count'] == 0) {
      database.execute(
        '''
      INSERT INTO _migrations (version, description, applied_at)
      VALUES (0, 'Initial version', ?);
      ''',
        <Object?>[DateTime.now().millisecondsSinceEpoch],
      );
    }

    debugPrint(' Tables and migrations initialized.');
  }

  Future<void> _applyMigrations(int fromVersion, int toVersion) async {
    database.execute('BEGIN TRANSACTION');

    try {
      for (int v = fromVersion + 1; v <= toVersion; v++) {
        final SqlEngineMigration migration = migrations.firstWhere(
          (SqlEngineMigration m) => m.version == v,
          orElse:
              () =>
                  throw SqlEngineException('Missing migration for version $v'),
        );

        database.execute(migration.up);
        database.execute(
          'INSERT INTO _migrations (version, description, applied_at) VALUES (?, ?, ?);',
          <Object?>[
            migration.version,
            migration.description,
            DateTime.now().millisecondsSinceEpoch,
          ],
        );

        // Ensure PRAGMA user_version is updated after each migration
        database.execute('PRAGMA user_version = $v;');
      }

      database.execute('COMMIT');
    } on Exception catch (e) {
      database.execute('ROLLBACK');
      throw SqlEngineException(
        'Migration failed from version $fromVersion to $toVersion',
        e,
      );
    }
  }

  /// Rollback to a specific version
  /// Rollback to a specific version using constructor-provided migrations
  Future<void> rollbackToVersion(int targetVersion) async {
    final ResultSet versionResult = database.select(
      'PRAGMA user_version;',
    ); // SQLite stores version in `PRAGMA user_version`

    final int currentVersion = versionResult.first['user_version'] as int;

    if (targetVersion >= currentVersion) {
      throw ArgumentError(
        'Target version must be less than the current version',
      );
    }

    database.execute('BEGIN TRANSACTION');

    try {
      for (int v = currentVersion; v > targetVersion; v--) {
        // Get migration matching this version
        final SqlEngineMigration migration = migrations.firstWhere(
          (SqlEngineMigration m) => m.version == v,
          orElse:
              () =>
                  throw SqlEngineException(
                    'No rollback migration found for version $v',
                  ),
        );

        // Execute rollback SQL
        database.execute(migration.down);
      }

      // Update the SQLite version after rollback
      database.execute('PRAGMA user_version = $targetVersion;');

      database.execute('COMMIT');
    } on Exception catch (e) {
      database.execute('ROLLBACK');
      throw SqlEngineException('Rollback to version $targetVersion failed', e);
    }
  }

  Future<List<Map<String, dynamic>>> queryRaw(
    String sql, [
    List<dynamic> parameters = const <dynamic>[],
  ]) async {
    try {
      if (enableLog) {
        debugPrint('[SQL] $sql\nParameters: $parameters');
      }
      return _db!.select(sql, parameters);
    } catch (e) {
      throw SqlEngineException('Error executing query: $sql', e);
    }
  }

  /// transaction
  ///
  Future<T> transaction<T>(Future<T> Function() action) async {
    try {
      await queryRaw('BEGIN TRANSACTION');
      final T result = await action();
      await queryRaw('COMMIT');
      return result;
    } catch (e) {
      await queryRaw('ROLLBACK');
      throw SqlEngineException('Transaction failed, rolled back', e);
    }
  }

  /// flushes the table, remove all data, [void] is returned
  Future<void> flush(String table) async {
    try {
      await queryRaw('DELETE FROM $table');
    } catch (e) {
      throw SqlEngineException('Error flushing $table', e);
    }
  }

  /// close database connection
  void close() {
    try {
      _db!.dispose();
    } catch (e) {
      throw SqlEngineException('Error closing database', e);
    }
  }

  /// Executes a raw SQL query with parameters.
  ///
  /// - [sql]: The SQL query to execute
  /// - [positionalParams]: List of parameters to bind to the query
  /// - [mapper]: Optional function to map the result to a specific type
  Future<T> runSql<T>(
    String sql, {
    List<Object?> positionalParams = const <Object?>[],
    T Function(List<Map<String, dynamic>>)? mapper,
  }) async {
    try {
      final CommonDatabase? database = _db;
      if (database == null) {
        throw SqlEngineException('Database not open');
      }

      // Log the query if logging is enabled
      if (enableLog) {
        debugPrint('[SQL] $sql');
        if (positionalParams.isNotEmpty) {
          debugPrint('Parameters: $positionalParams');
        }
      }

      // Prepare the SQL statement
      final CommonPreparedStatement stmt = database.prepare(sql);

      try {
        final bool isSelect = sql.trim().toUpperCase().startsWith('SELECT');
        if (isSelect) {
          // SELECT queries return a ResultSet
          final ResultSet resultSet = _executeSelect(stmt, positionalParams);
          final List<Map<String, dynamic>> queryResult =
              _convertResultSetToList(resultSet);
          return mapper != null ? mapper(queryResult) : queryResult as T;
        } else {
          // INSERT, UPDATE, DELETE just execute without returning rows
          final int result = _executeNonSelect(stmt, positionalParams, sql);
          if (T == int) {
            return result as T;
          } else {
            return <Map<String, int>>[
                  <String, int>{'result': result},
                ]
                as T;
          }
        }
      } finally {
        stmt.dispose();
      }
    } on Exception catch (e) {
      throw SqlEngineException('Error executing query: $sql', e);
    }
  }

  /// Executes a `SELECT` query and returns a `ResultSet`.
  ResultSet _executeSelect(
    CommonPreparedStatement stmt,
    List<Object?> positional,
  ) => stmt.select(positional);

  /// Executes an `INSERT`, `UPDATE`, or `DELETE` statement and returns the result:
  /// - `INSERT`: Returns the last inserted row ID.
  /// - `UPDATE` or `DELETE`: Returns the number of affected rows.
  int _executeNonSelect(
    CommonPreparedStatement stmt,
    List<Object?> positional,
    String sql,
  ) {
    database.execute('BEGIN TRANSACTION'); // Start transaction

    try {
      stmt.execute(positional);
      int result;
      if (sql.trim().toUpperCase().startsWith('INSERT')) {
        result = database.lastInsertRowId; // Safe inside transaction
      } else {
        result = database.updatedRows; // Number of affected rows
      }
      database.execute('COMMIT'); // Commit transaction
      return result;
    } catch (e) {
      database.execute('ROLLBACK'); // Rollback on error
      throw SqlEngineException('Error executing query: $sql', e);
    }
  }

  /// Converts a ResultSet to a List of Maps with proper type conversion
  List<Map<String, dynamic>> _convertResultSetToList(ResultSet resultSet) {
    final List<Map<String, dynamic>> result = <Map<String, dynamic>>[];
    for (final Row row in resultSet) {
      final Map<String, dynamic> convertedRow = <String, dynamic>{};
      for (final MapEntry<String, dynamic> entry in row.entries) {
        // Convert snake_case keys to camelCase for consistency with model
        //  final String key = _convertSnakeCaseToCamelCase(entry.key);
        // Pass the value directly - the model's fromRow method will handle conversion
        convertedRow[entry.key] = entry.value;
      }
      result.add(convertedRow);
    }
    return result;
  }

  void createFTSTable({
    required String tableName,
    required List<String> columns,
    bool contentless = false,
    String? externalContentTable,
    String? tokenize,
    String? prefix, // e.g. '2,3'
  }) {
    final String columnList = columns.join(', ');

    final List<String> options = <String>[];

    if (externalContentTable != null) {
      options.add("content='$externalContentTable'");
    } else if (contentless) {
      options.add("content=''");
    }

    if (tokenize != null) {
      options.add("tokenize='$tokenize'");
    }

    if (prefix != null) {
      options.add("prefix='$prefix'");
    }

    final String optionsSql =
        options.isNotEmpty ? ', ${options.join(', ')}' : '';

    final String sql = '''
    CREATE VIRTUAL TABLE $tableName USING fts5($columnList$optionsSql);
  ''';

    if (enableLog) {
      debugPrint('[SQL][FTS5] $sql');
    }
    database.execute(sql);
  }

  bool get fts5Supported {
    final ResultSet result = database.select('PRAGMA compile_options;');

    return result.any(
      (Row row) =>
          row.values.any((Object? v) => v.toString().contains('ENABLE_FTS5')),
    );
  }

  bool isFTS5Available() => fts5Supported;
}
