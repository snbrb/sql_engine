import 'package:sql_engine/sql_engine.dart';

part 'order.g.dart';

@SqlTable(tableName: 'orders', version: 1)
@SqlSchema(
  version: 1,
  columns: <SqlColumn>[
    SqlColumn(
      name: 'id',
      type: SqlType.integer,
      primaryKey: true,
      autoincrement: true,
      nullable: false,
    ),
    SqlColumn(
      name: 'customer_id',
      type: SqlType.integer,
      references: 'users',
      referenceColumn: 'id',
      nullable: false,
    ),
    SqlColumn(name: 'order_date', type: SqlType.date, nullable: false),
    SqlColumn(name: 'total', type: SqlType.real, nullable: false),
  ],
)
class Order {
  final int? id;
  final int customerId;
  final DateTime orderDate;
  final double total;

  const Order({
    required this.customerId,
    required this.orderDate,
    required this.total,
    this.id,
  });
}
