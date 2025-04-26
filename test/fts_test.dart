import 'package:flutter_test/flutter_test.dart';
import 'package:sql_engine/sql_engine.dart';

import 'models/order.dart';
import 'models/order_item.dart';
import 'models/user.dart';

void main() {
  late SqlEngineDatabase database;

  setUpAll(() async {
    // testDirectory = Directory.systemTemp.createTempSync();
    // final String dbPath = path.join(testDirectory.path, 'test_db.sqlite');
    //
    // if (File(dbPath).existsSync()) File(dbPath).deleteSync();

    database = SqlEngineDatabase();

    database.registerTable(<SqlEngineTable>[
      const UserTable(),
      const OrderTable(),
      const OrderItemTable(),
    ]);

    await database.open();
  });

  test('confirm if fts5 is enabled', () async {
    expect(database.isFTS5Available(), isTrue);
  });

  test('create fts table', () async {
    database.createFTSTable(
      tableName: 'fts_users',
      columns: <String>['name'],
      contentless: true,
      tokenize: 'unicode61',
      prefix: '2,3',
    );

    final int insertId = await database.runSql<int>(
      'INSERT INTO fts_users(rowid, name) VALUES (?, ?)',
      positionalParams: <Object?>[1, 'Jane Smith'],
    );

    print('insert record with $insertId');
  });
}
