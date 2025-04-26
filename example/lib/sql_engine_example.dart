import 'package:flutter/material.dart';
import 'package:sql_engine/sql_engine.dart';

import 'models/app_database.dart';
import 'models/user.dart';

class SqlEngineHomePage extends StatefulWidget {
  const SqlEngineHomePage({super.key});

  @override
  State<SqlEngineHomePage> createState() => _SqlEngineHomePageState();
}

class _SqlEngineHomePageState extends State<SqlEngineHomePage> {
  late final SqlEngineDatabase db;

  @override
  void initState() {
    super.initState();
    db = $AppDatabase(); // generated from @SqlDatabase
  }

  Future<void> _createDatabase() async {
    await db.open();
    _log('✅ Database created');
  }

  Future<void> _createModels() async {
    await db.flush('users');
    await db.flush('orders');
    await db.flush('order_items');
    _log('✅ Tables cleared');
  }

  Future<void> _insertData() async {
    await db.runSql(
      'INSERT INTO users (name, male, created_at) VALUES (?, ?, ?)',
      positionalParams: [
        'Ada Lovelace',
        1,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );
    _log('✅ Inserted user');
  }

  Future<void> _viewData() async {
    final users = await db.runSql<List<User>>(
      'SELECT * FROM users',
      mapper: (rows) => rows.map(UserMapper.fromRow).toList(),
    );
    _log('👤 Users: ${users.map((u) => u.name).join(', ')}');
  }

  Future<void> _viewJoinData() async {
    final rows = await db.runSql('''
      SELECT u.name, o.total, i.product_name
      FROM users u
      JOIN orders o ON u.id = o.customer_id
      JOIN order_items i ON o.id = i.order_id
      ''');
    _log('🔗 Join result: $rows');
  }

  Future<void> _upsertData() async {
    await db.runSql(
      '''
      INSERT INTO users (id, name, male, created_at)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(id) DO UPDATE SET name = excluded.name
      ''',
      positionalParams: [
        1,
        'Updated Ada',
        1,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );
    _log('🔁 Upserted user with id=1');
  }

  Future<void> _insertRelatedData() async {
    await db.runSql(
      'INSERT INTO orders (customer_id, order_date, total) VALUES (?, ?, ?)',
      positionalParams: [1, DateTime.now().millisecondsSinceEpoch, 150.0],
    );
    await db.runSql(
      'INSERT INTO order_items (order_id, product_name, quantity, price) VALUES (?, ?, ?, ?)',
      positionalParams: [1, 'Mechanical Keyboard', 1, 150.0],
    );
    _log('📦 Inserted related order + item');
  }

  Future<void> _selectRelatedData() async {
    final rows = await db.runSql('''
      SELECT u.name, o.total, i.product_name
      FROM users u
      JOIN orders o ON u.id = o.customer_id
      JOIN order_items i ON o.id = i.order_id
      ''');
    _log('📥 Related rows: $rows');
  }

  void _log(String msg) {
    debugPrint('[LOG] $msg');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = <MapEntry<String, VoidCallback>>[
      MapEntry('Create Database', _createDatabase),
      MapEntry('Create Models', _createModels),
      MapEntry('Insert Data', _insertData),
      MapEntry('View Data', _viewData),
      MapEntry('View data from join Tables', _viewJoinData),
      MapEntry('Upsert Data', _upsertData),
      MapEntry('Insert Related Data', _insertRelatedData),
      MapEntry('Select Related Data', _selectRelatedData),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('sql_engine Example')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final label = actions[index].key;
          final onPressed = actions[index].value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton(onPressed: onPressed, child: Text(label)),
          );
        },
      ),
    );
  }
}
