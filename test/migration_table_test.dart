// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sql_engine/sql_engine.dart';

import 'models/user_mg.dart';

void main() {
  test('migrates user_mg table from v1 ➜ v2', () async {
    final String fileName = Random().nextInt(1000).toString();
    final String filePath = path.join(
      Directory.systemTemp.path,
      'user_mg_migration_test$fileName.sqlite',
    );

    /* ───────────── 1. Create a v1 DB manually ───────────── */
    final SqlEngineDatabase dbV1 = SqlEngineDatabase(
      dbPath: filePath,
      version: 1, // target version
    )..registerTable(<SqlEngineTable>[const UserMgTable()]);
    await dbV1.open(); // uses createTableHistory[1]

    final int insertId = await dbV1.runSql<int>(
      'INSERT INTO user_mg (name) VALUES (?)',
      positionalParams: <Object?>['Ada'],
    );
    print('insertId: $insertId');
    dbV1.close();

    /* ───────────── 2. Reopen with version=2 and migration ───────────── */
    final SqlEngineDatabase dbV2 = SqlEngineDatabase(
      dbPath: filePath,
      version: 2, // target version
      migrations: <SqlEngineMigration>[
        ...UserMgTable.migrations, // ← add these
      ],
    );
    await dbV2.open(); // uses createTableHistory[1]

    dbV2.registerTable(<SqlEngineTable>[
      const UserMgTable(), // final table (v2)
    ]);

    await dbV2.open();

    // Check that migration renamed column and added email
    final List<Map<String, dynamic>> rows = await dbV2
        .runSql<List<Map<String, dynamic>>>('SELECT * FROM user_mg');

    expect(rows.length, equals(1));
    expect(rows.first['full_name'], equals('Ada'));
    expect(rows.first.containsKey('email'), isTrue);

    dbV2.close();
  });
}
