import 'package:sql_engine/sql_engine.dart';

import 'order.dart';
import 'order_item.dart';
import 'user.dart';

part 'app_database.g.dart';

@SqlDatabase(version: 1, models: <Type>[User, Order, OrderItem])
class AppDatabase {}
