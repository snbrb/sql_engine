// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison

part of 'order_item.dart';

// **************************************************************************
// SqlEngineGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

class OrderItemTable extends SqlEngineTable {
  const OrderItemTable() : super(tableName: 'order_items');

  @override
  Map<int, String> get createTableHistory => {
    1: r"""CREATE TABLE order_items (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  order_id integer NOT NULL REFERENCES orders(id),
  product_name text NOT NULL,
  quantity integer NOT NULL,
  price real NOT NULL
);
""",
  };

  @override
  List<Map<String, dynamic>> get initialSeedData => <Map<String, dynamic>>[];

  @override
  List<String> get createIndexes => [];

  @override
  String get createTable => r"""CREATE TABLE order_items (
  id integer PRIMARY KEY AUTOINCREMENT NOT NULL,
  order_id integer NOT NULL REFERENCES orders(id),
  product_name text NOT NULL,
  quantity integer NOT NULL,
  price real NOT NULL
);
""";

  static List<SqlEngineMigration> get migrations => [];
}

extension OrderItemMapper on OrderItem {
  static OrderItem fromRow(Map<String, dynamic> row) {
    return OrderItem(
      id: row['id'] as int,
      orderId: row['order_id'] as int,
      productName: row['product_name'] as String,
      quantity: row['quantity'] as int,
      price: (row['price'] as num).toDouble(),
    );
  }

  Map<String, Object?> toRow() {
    return {
      'id': id,
      'order_id': orderId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}

extension OrderItemCrud on SqlEngineDatabase {
  // INSERT ------------------------------------------------------------------
  Future<void> insertOrderItem(OrderItem entity) async {
    await runSql(
      'INSERT INTO order_items (id, order_id, product_name, quantity, price) VALUES (?, ?, ?, ?, ?)',
      positionalParams: <Object?>[
        entity.id,
        entity.orderId,
        entity.productName,
        entity.quantity,
        entity.price,
      ],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> deleteOrderItemById(Object? id) async => runSql<int>(
    'DELETE FROM order_items WHERE id = ?',
    positionalParams: <Object?>[id],
  );

  Future<int> deleteOrderItemWhere(String field, Object? value) async =>
      runSql<int>(
        'DELETE FROM order_items WHERE $field = ?',
        positionalParams: <Object?>[value],
      );

  Future<int> flushOrderItems() async => runSql<int>('DELETE FROM order_items');

  // UPDATE ------------------------------------------------------------------
  Future<void> updateOrderItem(OrderItem entity) async {
    await runSql(
      'UPDATE order_items SET order_id = ?, product_name = ?, quantity = ?, price = ? WHERE id = ?',
      positionalParams: <Object?>[
        entity.orderId,
        entity.productName,
        entity.quantity,
        entity.price,
        entity.id,
      ],
    );
  }

  // UPSERT ------------------------------------------------------------------
  Future<void> upsertOrderItem(OrderItem entity) async {
    await runSql(
      'INSERT INTO order_items (id, order_id, product_name, quantity, price) VALUES (?, ?, ?, ?, ?) '
      'ON CONFLICT(id) DO UPDATE SET order_id = ?, product_name = ?, quantity = ?, price = ?',
      positionalParams: <Object?>[
        entity.id,
        entity.orderId,
        entity.productName,
        entity.quantity,
        entity.price,
        entity.orderId,
        entity.productName,
        entity.quantity,
        entity.price,
      ],
    );
  }

  // SELECT ------------------------------------------------------------------
  Future<List<OrderItem>> findAllOrderItems() async => runSql<List<OrderItem>>(
    'SELECT * FROM order_items',
    mapper: (rows) => rows.map(OrderItemMapper.fromRow).toList(),
  );

  Future<List<OrderItem>> findOrderItemsWhere(
    String condition,
    List<Object?> positionalParams,
  ) async {
    return runSql<List<OrderItem>>(
      'SELECT * FROM order_items WHERE $condition',
      positionalParams: positionalParams,
      mapper: (rows) => rows.map(OrderItemMapper.fromRow).toList(),
    );
  }
}

class OrderItemCrudHelpers {
  static Future<void> insert(
    SqlEngineDatabase db, {
    required int id,
    required int orderId,
    required String productName,
    required int quantity,
    required double price,
  }) async {
    await db.insertOrderItem(
      OrderItem(
        id: id,
        orderId: orderId,
        productName: productName,
        quantity: quantity,
        price: price,
      ),
    );
  }

  static Future<void> update(
    SqlEngineDatabase db, {
    required int id,
    required int orderId,
    required String productName,
    required int quantity,
    required double price,
  }) async {
    await db.updateOrderItem(
      OrderItem(
        id: id,
        orderId: orderId,
        productName: productName,
        quantity: quantity,
        price: price,
      ),
    );
  }

  static Future<void> upsert(
    SqlEngineDatabase db, {
    required int id,
    required int orderId,
    required String productName,
    required int quantity,
    required double price,
  }) async {
    await db.upsertOrderItem(
      OrderItem(
        id: id,
        orderId: orderId,
        productName: productName,
        quantity: quantity,
        price: price,
      ),
    );
  }

  static Future<void> deleteById(SqlEngineDatabase db, Object? id) async {
    await db.deleteOrderItemById(id);
  }

  static Future<void> deleteIdWhere(SqlEngineDatabase db, Object? id) async {
    await db.deleteOrderItemById(id);
  }

  static Future<void> deleteWhere(
    SqlEngineDatabase db,
    String field,
    Object? value,
  ) async {
    await db.deleteOrderItemWhere(field, value);
  }

  static Future<List<OrderItem>> findAll(SqlEngineDatabase db) async {
    return await db.findAllOrderItems();
  }

  static Future<List<OrderItem>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams,
  ) async {
    return await db.findOrderItemsWhere(condition, positionalParams);
  }

  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flushOrderItems();
  }
}
