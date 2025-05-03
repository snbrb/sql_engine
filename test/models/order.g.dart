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
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  customer_id INTEGER NOT NULL REFERENCES users(id),
  order_date DATETIME NOT NULL,
  total REAL NOT NULL
);
""",
  };

  @override
  List<String> get createIndexes => [];

  @override
  String get createTable => r"""CREATE TABLE orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  customer_id INTEGER NOT NULL REFERENCES users(id),
  order_date DATETIME NOT NULL,
  total REAL NOT NULL
);
""";

  static List<SqlEngineMigration> get migrations => [];
}

extension OrderMapper on Order {
  static Order fromRow(Map<String, dynamic> row) {
    return Order(
      id: row['id'] as int,
      customerId: row['customer_id'] as int,
      orderDate: DateTime.fromMillisecondsSinceEpoch(row['order_date'] as int),
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
