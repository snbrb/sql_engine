import 'package:sql_engine/sql_engine.dart';

part 'order_item.g.dart';

@SqlTable(tableName: 'order_items', version: 1)
@SqlSchema(
  version: 1,
  columns: [
    SqlColumn(
      name: 'id',
      type: 'INTEGER',
      primaryKey: true,
      autoincrement: true,
      nullable: false,
    ),
    SqlColumn(
      name: 'order_id',
      type: 'INTEGER',
      references: 'orders',
      referenceColumn: 'id',
      nullable: false,
    ),
    SqlColumn(name: 'product_name', type: 'TEXT', nullable: false),
    SqlColumn(name: 'quantity', type: 'INTEGER', nullable: false),
    SqlColumn(name: 'price', type: 'REAL', nullable: false),
  ],
)
class OrderItem {
  final int? id;
  final int orderId;
  final String productName;
  final int quantity;
  final double price;

  const OrderItem({
    this.id,
    required this.orderId,
    required this.productName,
    required this.quantity,
    required this.price,
  });
}
