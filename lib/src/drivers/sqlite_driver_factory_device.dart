import 'package:sqlite3/common.dart';
import 'package:sqlite3/sqlite3.dart' as native;

// driver_factories/sqlite_driver_device.dart
import 'sqlite_driver_factory.dart';

class SqliteDriverFactoryDevice implements SqliteDriverFactory {
  @override
  Future<CommonDatabase> open(String dbPath) async {
    final native.Database db = native.sqlite3.open(dbPath);
    return db;
  }
}

SqliteDriverFactory createDriverFactory() => SqliteDriverFactoryDevice();
