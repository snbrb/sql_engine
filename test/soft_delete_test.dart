// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:sql_engine/sql_engine.dart';

import 'models/user.dart';

Future<void> seedSoftDeleteData(SqlEngineDatabase db) async {
  await UserCrudHelpers.flush(db);
  await UserCrudHelpers.insert(
    db,
    id: 1,
    name: 'Soft Alice',
    male: false,
    createdAt: DateTime.now(),
  );
  await UserCrudHelpers.insert(
    db,
    id: 2,
    name: 'Soft Bob',
    male: true,
    createdAt: DateTime.now(),
  );
}

void main() {
  late SqlEngineDatabase db;

  setUpAll(() async {
    db = SqlEngineDatabase(enableLog: true);
    db.registerTable(<SqlEngineTable>[const UserTable()]);
    await db.open();
    await seedSoftDeleteData(db);
  });

  test('Initial fetch returns all users', () async {
    final List<User> users = await UserCrudHelpers.findAll(db);
    expect(users.length, equals(2));
  });

  test('Soft delete user with id = 2', () async {
    await UserCrudHelpers.deleteById(db, 2);

    final List<User> users = await UserCrudHelpers.findAll(db);
    final bool hasBob = users.any((User u) => u.id == 2);
    expect(hasBob, isFalse);
  });

  test('Soft-deleted user remains in database with deleted_at set', () async {
    final List<User> rows = await db.runSql<List<User>>(
      'SELECT * FROM users WHERE id = 2',
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(UserMapper.fromRow).toList(),
    );

    expect(rows, isNotEmpty);
    expect(rows.first.deletedAt, isNotNull);
  });

  test('findAll(includeDeleted: true) includes soft-deleted users', () async {
    final List<User> all = await UserCrudHelpers.findAll(
      db,
      includeDeleted: true,
    );
    expect(all.any((User u) => u.id == 2), isTrue);
  });

  test('Restore soft-deleted user by id', () async {
    await UserCrudHelpers.restoreById(db, 2);

    final List<User> users = await UserCrudHelpers.findAll(db);
    expect(users.any((User u) => u.id == 2), isTrue);

    final User restored = users.firstWhere((User u) => u.id == 2);
    expect(restored.deletedAt, isNull);
  });
}
