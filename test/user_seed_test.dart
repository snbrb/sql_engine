import 'package:flutter_test/flutter_test.dart';
import 'package:sql_engine/sql_engine.dart';

import 'models/user.dart';

void main() {
  late SqlEngineDatabase database;

  setUp(() async {
    database = SqlEngineDatabase(enableLog: false);

    database.registerTable(<SqlEngineTable>[const UserTable()]);

    await database.open();
  });

  tearDown(() async {
    database.close();
  });

  test('Seed data is inserted into users table on creation', () async {
    // Query all users
    final List<User> users = await UserCrudHelpers.findAll(database);

    expect(users.length, 2);

    // ignore: avoid_print
    print('tota users ${users.length}');
    final User alice = users.firstWhere((User u) => u.name == 'Alice');
    expect(alice.male, isFalse);
    expect(alice.createdAt?.millisecondsSinceEpoch, 1717800000000);

    final User bob = users.firstWhere((User u) => u.name == 'Bob');
    expect(bob.male, isTrue);
    expect(bob.createdAt?.millisecondsSinceEpoch, 1717900000000);
  });
}
