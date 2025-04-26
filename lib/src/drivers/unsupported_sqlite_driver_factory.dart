import 'package:sqlite3/common.dart';

import 'sqlite_driver_factory.dart';

class UnsupportedSqliteDriverFactory implements SqliteDriverFactory {
  @override
  Future<CommonDatabase> open(String dbPath) {
    throw UnsupportedError('SQLite is not supported on this platform.');
  }
}
