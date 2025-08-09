// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:sql_engine/sql_engine.dart';

import 'models/order.dart';
import 'models/order_item.dart';
import 'models/user.dart';

Future<void> createSampleData(SqlEngineDatabase db) async {
  await UserCrudHelpers.flush(db);
  await OrderCrudHelpers.flush(db);
  await OrderItemCrudHelpers.flush(db);

  await UserCrudHelpers.insert(
    db,
    id: 1,
    name: 'Jane Smith',
    male: true,
    createdAt: DateTime.now(),
  );
  await UserCrudHelpers.insert(
    db,
    id: 2,
    name: 'John Doe',
    male: false,
    createdAt: DateTime.now(),
  );
  await UserCrudHelpers.insert(
    db,
    id: 3,
    name: 'Greame Davies',
    male: true,
    createdAt: DateTime.now(),
  );

  await OrderCrudHelpers.insert(
    db,
    id: 1,
    customerId: 1,
    orderDate: DateTime.now(),
    total: 100.50,
  );
  await OrderCrudHelpers.insert(
    db,
    id: 2,
    customerId: 1,
    orderDate: DateTime.now(),
    total: 75.25,
  );
  await OrderCrudHelpers.insert(
    db,
    id: 3,
    customerId: 2,
    orderDate: DateTime.now(),
    total: 200.00,
  );

  await OrderItemCrudHelpers.insert(
    db,
    id: 1,
    orderId: 1,
    productName: 'Product A',
    quantity: 2,
    price: 10.99,
  );
  await OrderItemCrudHelpers.insert(
    db,
    id: 2,
    orderId: 1,
    productName: 'Product B',
    quantity: 1,
    price: 15.50,
  );
  await OrderItemCrudHelpers.insert(
    db,
    id: 3,
    orderId: 2,
    productName: 'Product C',
    quantity: 3,
    price: 5.25,
  );
  await OrderItemCrudHelpers.insert(
    db,
    id: 4,
    orderId: 3,
    productName: 'Product A',
    quantity: 1,
    price: 10.99,
  );
}

void main() {
  late SqlEngineDatabase db;

  setUpAll(() async {
    db = SqlEngineDatabase(enableLog: true);

    db.registerTable(<SqlEngineTable>[
      const UserTable(),
      const OrderTable(),
      const OrderItemTable(),
    ]);

    await db.open();
    await createSampleData(db);
  });

  test('Fetch all users', () async {
    final List<User> users = await UserCrudHelpers.findAll(db);
    print('Users: \$users');
    expect(users.length, greaterThanOrEqualTo(3));
  });

  test('Fetch all orders', () async {
    final List<Order> orders = await OrderCrudHelpers.findAll(db);
    print('Orders: \$orders');
    expect(orders.length, equals(3));
  });

  test('Fetch all order items', () async {
    final List<OrderItem> items = await OrderItemCrudHelpers.findAll(db);
    print('OrderItems: \$items');
    expect(items.length, equals(4));
  });

  test('Find user by name', () async {
    final List<User> users = await UserCrudHelpers.findWhere(
      db,
      'name = ?',
      <Object?>['Jane Smith'], // Not wrapped in another list
    );
    expect(users.first.name, equals('Jane Smith'));
  });

  test('Update user name', () async {
    await UserCrudHelpers.upsert(
      db,
      id: 3,
      name: 'Updated Greame',
      male: true,
      createdAt: DateTime.now(),
    );
    final List<User> updated = await UserCrudHelpers.findWhere(
      db,
      'id = ?',
      <int>[3],
    );
    expect(updated.first.name, equals('Updated Greame'));
  });

  test('Delete specific user', () async {
    await UserCrudHelpers.deleteIdWhere(db, 2);
    final List<User> users = await UserCrudHelpers.findAll(db);
    expect(users.any((User u) => u.id == 2), isFalse);
  });

  test('Flush order_items', () async {
    await OrderItemCrudHelpers.flush(db);
    final List<OrderItem> items = await OrderItemCrudHelpers.findAll(db);
    expect(items, isEmpty);
  });
}
