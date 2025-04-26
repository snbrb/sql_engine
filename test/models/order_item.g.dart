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
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  order_id INTEGER NOT NULL REFERENCES orders(id),
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  price REAL NOT NULL
);
""",
  };

  @override
  String get createTable => r"""CREATE TABLE order_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  order_id INTEGER NOT NULL REFERENCES orders(id),
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  price REAL NOT NULL
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
