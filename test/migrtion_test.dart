import 'package:flutter_test/flutter_test.dart';
import 'package:sql_engine/sql_engine.dart';

import 'models/user_mg.dart';

void main() {
  late SqlEngineDatabase database;

  setUpAll(() async {
    database = SqlEngineDatabase(version: 2);
    database.registerTable(<SqlEngineTable>[
      const UserMgTable(), //  new table
    ]);
    await database.open(); // will run createTable (fresh) OR migrate (v1→v2)
  });

  test('insert & search', () async {
    await database.runSql(
      'INSERT INTO user_mg (full_name, email) VALUES (?, ?)',
      positionalParams: <Object?>['Ada Lovelace', 'ada@history.com'],
    );

    final List<Map<String, dynamic>> rows = await database
        .runSql<List<Map<String, dynamic>>>('SELECT * FROM user_mg');
    expect(rows.first['full_name'], 'Ada Lovelace');
  });
}
