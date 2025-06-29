// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison

part of 'order.dart';

// **************************************************************************
// SqlEngineGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

class OrderTable extends SqlEngineTable {
  const OrderTable() : super(tableName: 'orders');

  @override
  Map<int, String> get createTableHistory => {
    1: r"""CREATE TABLE orders (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  customer_id integer NOT NULL REFERENCES users(id),
  order_date DATE NOT NULL,
  total real NOT NULL
);
""",
  };

  @override
  List<Map<String, dynamic>> get initialSeedData => <Map<String, dynamic>>[];

  @override
  List<String> get createIndexes => [];

  @override
  String get createTable => r"""CREATE TABLE orders (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  customer_id integer NOT NULL REFERENCES users(id),
  order_date DATE NOT NULL,
  total real NOT NULL
);
""";

  static List<SqlEngineMigration> get migrations => [];
}

extension OrderMapper on Order {
  static Order fromRow(Map<String, dynamic> row) {
    return Order(
      id: row['id'] as int,
      customerId: row['customer_id'] as int,
      orderDate: DateTime.fromMillisecondsSinceEpoch(
        row['order_date'] is int
            ? row['order_date'] as int
            : int.tryParse('${row['order_date']}') ?? 0,
      ),
      total: (row['total'] as num).toDouble(),
    );
  }

  Map<String, Object?> toRow() {
    return {
      'id': id,
      'customer_id': customerId,
      'order_date': orderDate.millisecondsSinceEpoch,
      'total': total,
    };
  }
}

extension OrderCrud on SqlEngineDatabase {
  // INSERT ------------------------------------------------------------------
  Future<void> insertOrder(Order entity) async {
    await runSql(
      'INSERT INTO orders (id, customer_id, order_date, total) VALUES (?, ?, ?, ?)',
      positionalParams: <dynamic>[
        entity.id,
        entity.customerId,
        entity.orderDate.millisecondsSinceEpoch,
        entity.total,
      ],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> deleteOrderById(dynamic id) async => runSql<int>(
    'DELETE FROM orders WHERE id = ?',
    positionalParams: <dynamic>[id],
  );

  Future<int> deleteOrderWhere(String field, dynamic value) async =>
      runSql<int>(
        'DELETE FROM orders WHERE $field = ?',
        positionalParams: <dynamic>[value],
      );

  Future<int> flushOrders() async => runSql<int>('DELETE FROM orders');

  // RESTORE ------------------------------------------------------------------
  Future<int> restoreOrderById(dynamic id) async => runSql<int>(
    'UPDATE orders SET deleted_at = NULL WHERE id = ?',
    positionalParams: <dynamic>[id],
  );

  // UPDATE ------------------------------------------------------------------
  Future<void> updateOrder(Order entity) async {
    await runSql(
      'UPDATE orders SET customer_id = ?, order_date = ?, total = ? WHERE id = ?',
      positionalParams: <dynamic>[
        entity.customerId,
        entity.orderDate.millisecondsSinceEpoch,
        entity.total,
        entity.id,
      ],
    );
  }

  // UPSERT ------------------------------------------------------------------
  Future<void> upsertOrder(Order entity) async {
    await runSql(
      'INSERT INTO orders (id, customer_id, order_date, total) VALUES (?, ?, ?, ?) '
      'ON CONFLICT(id) DO UPDATE SET customer_id = ?, order_date = ?, total = ?',
      positionalParams: <dynamic>[
        entity.id,
        entity.customerId,
        entity.orderDate.millisecondsSinceEpoch,
        entity.total,
        entity.customerId,
        entity.orderDate.millisecondsSinceEpoch,
        entity.total,
      ],
    );
  }

  // SELECT ------------------------------------------------------------------
  Future<List<Order>> findAllOrders({bool includeDeleted = false}) async {
    final String query = 'SELECT * FROM orders';

    return runSql<List<Order>>(
      query,
      mapper: (rows) => rows.map(OrderMapper.fromRow).toList(),
    );
  }

  Future<List<Order>> findOrdersWhere(
    String condition,
    List<dynamic> positionalParams, {
    bool includeDeleted = false,
  }) async {
    final String query = 'SELECT * FROM orders WHERE $condition';

    return runSql<List<Order>>(
      query,
      positionalParams: positionalParams,
      mapper: (rows) => rows.map(OrderMapper.fromRow).toList(),
    );
  }
}

class OrderCrudHelpers {
  static Future<void> insert(
    SqlEngineDatabase db, {
    required int id,
    required int customerId,
    required DateTime orderDate,
    required double total,
  }) async {
    await db.insertOrder(
      Order(id: id, customerId: customerId, orderDate: orderDate, total: total),
    );
  }

  static Future<void> update(
    SqlEngineDatabase db, {
    required int id,
    required int customerId,
    required DateTime orderDate,
    required double total,
  }) async {
    await db.updateOrder(
      Order(id: id, customerId: customerId, orderDate: orderDate, total: total),
    );
  }

  static Future<void> upsert(
    SqlEngineDatabase db, {
    required int id,
    required int customerId,
    required DateTime orderDate,
    required double total,
  }) async {
    await db.upsertOrder(
      Order(id: id, customerId: customerId, orderDate: orderDate, total: total),
    );
  }

  static Future<void> deleteById(SqlEngineDatabase db, Object? id) async {
    await db.deleteOrderById(id);
  }

  static Future<void> deleteIdWhere(SqlEngineDatabase db, Object? id) async {
    await db.deleteOrderById(id);
  }

  static Future<void> deleteWhere(
    SqlEngineDatabase db,
    String field,
    Object? value,
  ) async {
    await db.deleteOrderWhere(field, value);
  }

  static Future<List<Order>> findAll(
    SqlEngineDatabase db, {
    bool includeDeleted = false,
  }) async {
    return await db.findAllOrders(includeDeleted: includeDeleted);
  }

  static Future<List<Order>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams, {
    bool includeDeleted = false,
  }) async {
    return await db.findOrdersWhere(
      condition,
      positionalParams,
      includeDeleted: includeDeleted,
    );
  }

  static Future<void> restoreById(SqlEngineDatabase db, dynamic id) async {
    await db.runSql(
      'UPDATE orders SET deleted_at = NULL WHERE id = ?',
      positionalParams: <Object?>[id],
    );
  }

  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flushOrders();
  }
}
