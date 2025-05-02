// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:sql_engine/sql_engine.dart';

import 'models/order.dart';
import 'models/order_item.dart';
import 'models/user.dart';

Future<void> createSampleData(SqlEngineDatabase db) async {
  await db.flush('users');
  await db.flush('orders');
  await db.flush('order_items');

  // Users
  await db.runSql(
    'INSERT INTO users (id, name, male, created_at) VALUES (?, ?, ?, ?)',
    positionalParams: <Object?>[
      1,
      'Jane Smith',
      1,
      DateTime.now().millisecondsSinceEpoch,
    ],
  );
  await db.runSql(
    'INSERT INTO users (id, name, male, created_at) VALUES (?, ?, ?, ?)',
    positionalParams: <Object?>[
      2,
      'John Doe',
      0,
      DateTime.now().millisecondsSinceEpoch,
    ],
  );
  await db.runSql(
    'INSERT INTO users (id, name, male, created_at) VALUES (?, ?, ?, ?)',
    positionalParams: <Object?>[
      3,
      'Greame Davies',
      1,
      DateTime.now().millisecondsSinceEpoch,
    ],
  );

  // Orders
  await db.runSql(
    'INSERT INTO orders (id, customer_id, order_date, total) VALUES (?, ?, ?, ?)',
    positionalParams: <Object?>[
      1,
      1,
      DateTime.now().millisecondsSinceEpoch,
      100.50,
    ],
  );
  await db.runSql(
    'INSERT INTO orders (id, customer_id, order_date, total) VALUES (?, ?, ?, ?)',
    positionalParams: <Object?>[
      2,
      1,
      DateTime.now().millisecondsSinceEpoch,
      75.25,
    ],
  );
  await db.runSql(
    'INSERT INTO orders (id, customer_id, order_date, total) VALUES (?, ?, ?, ?)',
    positionalParams: <Object?>[
      3,
      2,
      DateTime.now().millisecondsSinceEpoch,
      200.00,
    ],
  );

  // Order Items
  await db.runSql(
    'INSERT INTO order_items (id, order_id, product_name, quantity, price) VALUES '
    '(1, 1, "Product A", 2, 10.99), '
    '(2, 1, "Product B", 1, 15.50), '
    '(3, 2, "Product C", 3, 5.25), '
    '(4, 3, "Product A", 1, 10.99)',
  );
}

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
    await createSampleData(database);
  });

  test('Join: users + orders + order_items', () async {
    final List<Map<String, dynamic>> result = await database.runSql(
      '''
      SELECT users.name, orders.total, order_items.product_name
      FROM users
      INNER JOIN orders ON users.id = orders.customer_id
      INNER JOIN order_items ON orders.id = order_items.order_id
      WHERE users.id = ?
    ''',
      positionalParams: <Object?>[1],
    );

    print('JOIN RESULT: $result');
    expect(result, isNotEmpty);
    expect(result.first['name'], equals('Jane Smith'));
  });

  test('Group By + Count', () async {
    final dynamic result = await database.runSql('''
      SELECT customer_id, COUNT(*) as orderCount
      FROM orders
      GROUP BY customer_id
    ''');

    print('GROUP BY RESULT: $result');
    expect(result.first.containsKey('orderCount'), isTrue);
  });

  test('Having + Sum', () async {
    final dynamic result = await database.runSql(
      '''
      SELECT customer_id, SUM(total) as totalSpent
      FROM orders
      GROUP BY customer_id
      HAVING totalSpent > ?
    ''',
      positionalParams: <Object?>[100.0],
    );

    print('HAVING RESULT: $result');
    expect(result, isNotEmpty);
  });

  test('Upsert User', () async {
    final int result = await database.runSql<int>(
      '''
      INSERT INTO users (id, name, male, created_at)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET name = excluded.name
    ''',
      positionalParams: <Object?>[
        3,
        'Updated Greame',
        1,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );

    print('UPSERT RESULT: $result');
    final dynamic verify = await database.runSql(
      'SELECT * FROM users WHERE id = ?',
      positionalParams: <Object?>[3],
    );
    expect(verify.first['name'], equals('Updated Greame'));
  });

  test('Window Function AVG per customer', () async {
    final dynamic result = await database.runSql('''
      SELECT customer_id, total,
        AVG(total) OVER (PARTITION BY customer_id) as avgTotal
      FROM orders
    ''');

    print('WINDOW FUNCTION RESULT: $result');
    expect(result.first.containsKey('avgTotal'), isTrue);
  });

  test('Subquery with EXISTS', () async {
    final dynamic result = await database.runSql(
      '''
      SELECT * FROM users u
      WHERE EXISTS (
        SELECT 1 FROM orders o
        WHERE o.customer_id = u.id AND o.total > ?
      )
    ''',
      positionalParams: <Object?>[150.0],
    );

    print('SUBQUERY EXISTS RESULT: $result');
    expect(result, isNotEmpty);
  });

  test('Invalid SQL throws exception', () async {
    expect(
      () => database.runSql('INVALID SQL SYNTAX'),
      throwsA(isA<SqlEngineException>()),
    );
  });

  /*----------------------MAPPER TEST-------------------------------*/

  test('Select all users mapped', () async {
    final dynamic users = await database.runSql<List<Map<String, dynamic>>>(
      'SELECT * FROM users',
    );
    print('Mapped USERS: $users');
    try {
      users.map((Map<String, dynamic> row) {
        print(row);
        return row;
      }).toList();
    } on Exception catch (e) {
      print(e);
    }
    // final List<User> userss = await database.runRawQuery<List<User>>(
    //   'SELECT * FROM users',
    //   mapper:
    //       (List<Map<String, dynamic>> rows) =>
    //           rows.map(UserMapper.fromRow).toList(),
    // );

    // expect(users.length, greaterThanOrEqualTo(3));
  });

  test('Select all orders mapped', () async {
    final List<Order> orders = await database.runSql<List<Order>>(
      'SELECT * FROM orders',
      mapper: (List<Map<String, dynamic>> rows) {
        print(rows);
        return rows.map(OrderMapper.fromRow).toList();
      },
    );

    print('Mapped ORDERS: $orders');
    expect(orders.length, equals(3));
  });

  test('Select all order items mapped', () async {
    final List<OrderItem> items = await database.runSql<List<OrderItem>>(
      'SELECT * FROM order_items',
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(OrderItemMapper.fromRow).toList(),
    );

    print('Mapped ORDER ITEMS: $items');
    expect(items.length, equals(4));
  });

  test('Find user by name', () async {
    final List<User> users = await database.runSql<List<User>>(
      'SELECT * FROM users WHERE name = ?',
      positionalParams: <Object?>['Jane Smith'],
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(UserMapper.fromRow).toList(),
    );

    expect(users.first.name, equals('Jane Smith'));
  });

  test('Find orders over 100', () async {
    final List<Order> orders = await database.runSql<List<Order>>(
      'SELECT * FROM orders WHERE total > ?',
      positionalParams: <Object?>[100.0],
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(OrderMapper.fromRow).toList(),
    );

    expect(orders.first.total, greaterThan(100.0));
  });

  test('Find order items with quantity >= 2', () async {
    final List<OrderItem> items = await database.runSql<List<OrderItem>>(
      'SELECT * FROM order_items WHERE quantity >= ?',
      positionalParams: <Object?>[2],
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(OrderItemMapper.fromRow).toList(),
    );

    expect(items.any((OrderItem i) => i.quantity >= 2), isTrue);
  });

  test('List users with at least one order', () async {
    final List<User> users = await database.runSql<List<User>>(
      '''
      SELECT DISTINCT u.*
      FROM users u
      JOIN orders o ON u.id = o.customer_id
    ''',
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(UserMapper.fromRow).toList(),
    );

    expect(users, isNotEmpty);
  });

  test('Orders with at least 2 items', () async {
    final List<Order> orders = await database.runSql<List<Order>>(
      '''
      SELECT o.*
      FROM orders o
      JOIN (
        SELECT order_id FROM order_items GROUP BY order_id HAVING COUNT(*) >= 2
      ) x ON o.id = x.order_id
    ''',
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(OrderMapper.fromRow).toList(),
    );

    expect(orders.length, greaterThanOrEqualTo(1));
  });

  test('Fetch order items for order ID 1', () async {
    final List<OrderItem> items = await database.runSql<List<OrderItem>>(
      'SELECT * FROM order_items WHERE order_id = ?',
      positionalParams: <Object?>[1],
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(OrderItemMapper.fromRow).toList(),
    );

    expect(items.length, equals(2));
  });

  test('Subquery mapped: Users who spent > 150', () async {
    final List<User> users = await database.runSql<List<User>>(
      '''
      SELECT * FROM users
      WHERE id IN (
        SELECT customer_id FROM orders GROUP BY customer_id HAVING SUM(total) > 150
      )
    ''',
      mapper:
          (List<Map<String, dynamic>> rows) =>
              rows.map(UserMapper.fromRow).toList(),
    );

    expect(users, isNotEmpty);
  });
}
