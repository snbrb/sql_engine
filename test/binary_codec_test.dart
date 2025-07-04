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
    database = SqlEngineDatabase(enableLog: false);

    database.registerTable(<SqlEngineTable>[
      const UserTable(),
      const OrderTable(),
      const OrderItemTable(),
    ]);

    await database.open();
    await createSampleData(database);
  });

  group('Binary codec – User', () {
    test('full field-round-trip (nullable values present)', () {
      final User original = User(
        id: 42,
        name: 'Alice',
        male: true,
        createdAt: DateTime(2025, 6, 15, 12, 34, 56),
        data: Uint8List.fromList([1, 2, 3, 4]),
        deletedAt: null, // still active → null
      );

      // ---- serialise → bytes ----
      final Uint8List bytes = original.toBytes();

      // ---- de-serialise ← bytes ----
      final User decoded = UserBinary.fromBytes(bytes);

      // ---- expect equality on every field ----
      expect(decoded.id, original.id);
      expect(decoded.name, original.name);
      expect(decoded.male, original.male);
      expect(decoded.createdAt, original.createdAt);
      expect(decoded.data, original.data);
      expect(decoded.deletedAt, original.deletedAt);
    });

    test('handles nullable columns = null', () {
      final User original = User(
        id: 7,
        name: 'Bob',
        male: null,
        createdAt: null,
        data: null,
        deletedAt: DateTime(2026, 1, 1, 9), // soft-deleted row
      );

      final User decoded = UserBinary.fromBytes(original.toBytes());

      expect(decoded.id, original.id);
      expect(decoded.name, original.name);
      expect(decoded.male, isNull);
      expect(decoded.createdAt, isNull);
      expect(decoded.data, isNull);
      expect(decoded.deletedAt, original.deletedAt);
    });
  });

  group('Binary codec – Order', () {
    test('round-trip all non-nullable fields', () {
      final Order original = Order(
        id: 9,
        customerId: 42,
        orderDate: DateTime(2025, 7, 1, 18, 0),
        total: 123.45,
      );

      final Order decoded = OrderBinary.fromBytes(original.toBytes());

      expect(decoded.id, original.id);
      expect(decoded.customerId, original.customerId);
      expect(decoded.orderDate, original.orderDate);
      expect(decoded.total, original.total);
    });
  });
}
