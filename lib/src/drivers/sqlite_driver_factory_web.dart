// ignore_for_file: avoid_print

import 'package:sqlite3/wasm.dart';

import '../config.dart';
import 'sqlite_driver_factory.dart'; // for `enableLog`

class SqliteDriverFactoryWeb implements SqliteDriverFactory {
  late final WasmSqlite3 _sqlite3;

  @override
  Future<CommonDatabase> open(String dbPath) async {
    _sqlite3 = await WasmSqlite3.loadFromUrl(
      Uri.parse('sqlite3.wasm'), // or use `sqlite3.wasm` for release
    );

    if (enableLog) {
      print('[SQLITE3][WEB] SQLite version: ${_sqlite3.version}');
    }

    // Register IndexedDB as the file system backend
    _sqlite3.registerVirtualFileSystem(
      await IndexedDbFileSystem.open(dbName: dbPath),
      makeDefault: true,
    );

    // Open the database (typically `/db.sqlite` or similar)
    return _sqlite3.open('/$dbPath');
  }
}

SqliteDriverFactory createDriverFactory() => SqliteDriverFactoryWeb();
