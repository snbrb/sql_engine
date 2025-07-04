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
      positionalParams: <dynamic>[
        entity.id,
        entity.orderId,
        entity.productName,
        entity.quantity,
        entity.price,
      ],
    );
  }

  // DELETE ------------------------------------------------------------------
  Future<int> deleteOrderItemById(dynamic id) async => runSql<int>(
    'DELETE FROM order_items WHERE id = ?',
    positionalParams: <dynamic>[id],
  );

  Future<int> deleteOrderItemWhere(String field, dynamic value) async =>
      runSql<int>(
        'DELETE FROM order_items WHERE $field = ?',
        positionalParams: <dynamic>[value],
      );

  Future<int> flushOrderItems() async => runSql<int>('DELETE FROM order_items');

  // RESTORE ------------------------------------------------------------------
  Future<int> restoreOrderItemById(dynamic id) async => runSql<int>(
    'UPDATE order_items SET deleted_at = NULL WHERE id = ?',
    positionalParams: <dynamic>[id],
  );

  // UPDATE ------------------------------------------------------------------
  Future<void> updateOrderItem(OrderItem entity) async {
    await runSql(
      'UPDATE order_items SET order_id = ?, product_name = ?, quantity = ?, price = ? WHERE id = ?',
      positionalParams: <dynamic>[
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
      positionalParams: <dynamic>[
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
  Future<List<OrderItem>> findAllOrderItems({
    bool includeDeleted = false,
  }) async {
    final String query = 'SELECT * FROM order_items';

    return runSql<List<OrderItem>>(
      query,
      mapper: (rows) => rows.map(OrderItemMapper.fromRow).toList(),
    );
  }

  Future<List<OrderItem>> findOrderItemsWhere(
    String condition,
    List<dynamic> positionalParams, {
    bool includeDeleted = false,
  }) async {
    final String query = 'SELECT * FROM order_items WHERE $condition';

    return runSql<List<OrderItem>>(
      query,
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

  static Future<List<OrderItem>> findAll(
    SqlEngineDatabase db, {
    bool includeDeleted = false,
  }) async {
    return await db.findAllOrderItems(includeDeleted: includeDeleted);
  }

  static Future<List<OrderItem>> findWhere(
    SqlEngineDatabase db,
    String condition,
    List<Object?> positionalParams, {
    bool includeDeleted = false,
  }) async {
    return await db.findOrderItemsWhere(
      condition,
      positionalParams,
      includeDeleted: includeDeleted,
    );
  }

  static Future<void> restoreById(SqlEngineDatabase db, dynamic id) async {
    await db.runSql(
      'UPDATE order_items SET deleted_at = NULL WHERE id = ?',
      positionalParams: <Object?>[id],
    );
  }

  static Future<void> flush(SqlEngineDatabase db) async {
    await db.flushOrderItems();
  }
}

extension OrderItemBinary on OrderItem {
  // ---- helpers -----------------------------------------------------------
  static Uint8List _i32(int v) {
    final b = ByteData(4)..setInt32(0, v, Endian.little);
    return b.buffer.asUint8List();
  }

  static Uint8List _i64(int v) {
    final b = ByteData(8)..setInt64(0, v, Endian.little);
    return b.buffer.asUint8List();
  }

  static Uint8List _f64(double v) {
    final b = ByteData(8)..setFloat64(0, v, Endian.little);
    return b.buffer.asUint8List();
  }

  // ---- encode ------------------------------------------------------------
  Uint8List toBytes() {
    final buf = BytesBuilder();
    // int id
    buf.add(_i64(this.id as int));
    // int order_id
    buf.add(_i64(this.orderId as int));
    // string product_name
    final List<int> _b2 = utf8.encode(this.productName as String);
    buf.add(_i32(_b2.length));
    buf.add(_b2);
    // int quantity
    buf.add(_i64(this.quantity as int));
    // double price
    buf.add(_f64(this.price as double));

    return buf.takeBytes();
  }

  // ---- decode ------------------------------------------------------------
  static OrderItem fromBytes(Uint8List input) {
    final bv = input.buffer.asByteData();
    int _ofs = 0;
    int _next() => input[_ofs++]; // 1 byte shortcut
    int _readI32() {
      final v = bv.getInt32(_ofs, Endian.little);
      _ofs += 4;
      return v;
    }

    int _readI64() {
      final v = bv.getInt64(_ofs, Endian.little);
      _ofs += 8;
      return v;
    }

    double _readF64() {
      final v = bv.getFloat64(_ofs, Endian.little);
      _ofs += 8;
      return v;
    }

    late int id;
    late int orderId;
    late String productName;
    late int quantity;
    late double price;

    id = _readI64();
    orderId = _readI64();
    final int _len2 = _readI32();
    productName = utf8.decode(input.sublist(_ofs, _ofs + _len2));
    _ofs += _len2;
    quantity = _readI64();
    price = _readF64();

    return OrderItem(
      id: id,
      orderId: orderId,
      productName: productName,
      quantity: quantity,
      price: price,
    );
  }
}
