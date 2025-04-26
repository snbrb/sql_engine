import 'package:sqlite3/common.dart';

import 'sqlite_driver_factory.dart';

class SqliteDriverFactoryStub implements SqliteDriverFactory {
  @override
  Future<CommonDatabase> open(String dbPath) {
    throw UnsupportedError('SQLite not supported on this platform.');
  }
}

SqliteDriverFactory createDriverFactory() => SqliteDriverFactoryStub();
