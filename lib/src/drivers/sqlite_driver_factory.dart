import 'package:sqlite3/common.dart';

import 'sqlite_driver_factory_selector.dart' show createDriverFactory;

abstract class SqliteDriverFactory {
  Future<CommonDatabase> open(String dbPath);
}

SqliteDriverFactory getDriverFactory() => createDriverFactory();
