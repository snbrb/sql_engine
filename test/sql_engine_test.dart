// import 'package:sql_engine/sql_engine.dart';
//
// import 'models/user.dart';
//
// void main() async {
//   // Define the test user data
//   // Step 1: Define test input
//   final User testUser = User(
//     fullName: 'Alice Anderson',
//     email: 'alice@example.com',
//     isActive: 1,
//     createdAt: DateTime.now().toIso8601String(),
//     age: 30,
//     balance: 99.95,
//     bio: 'This is a test user',
//   );
//
//   print('INPUT USER: $testUser');
//
//   // Step 2: Create in-memory database
//   final SqlEngineDatabase database = SqlEngineDatabase();
//
//   // Step 3: Register tables (UserTable is generated, not the User model)
//   database.registerTable(<SqlEngineTable>[
//     const UserTable(), // This should be generated from user.g.dart
//   ]);
//
//   // Step 4: Open DB (applies migrations & creates schema)
//   await database.open();
//
//   // Step 5: Insert user using runRawQuery
//   final int insertedId = await database.runRawQuery<int>(
//     'INSERT INTO users '
//     '(full_name, email, is_active, created_at, age, balance, bio) '
//     'VALUES (?, ?, ?, ?, ?, ?, ?)',
//     positionalParams: <Object?>[
//       testUser.fullName,
//       testUser.email,
//       testUser.isActive,
//       testUser.createdAt,
//       testUser.age,
//       testUser.balance,
//       testUser.bio,
//     ],
//   );
//
//   print('INSERTED USER ID: $insertedId');
//
//   // Step 6: Fetch users
//   final List<Map<String, dynamic>> users = await database.runRawQuery(
//     'SELECT * FROM users;',
//   );
//
//   print('SELECTED ROWS:');
//   for (final Map<String, dynamic> row in users) {
//     print(row);
//   }
//
//   // Step 7: Close
//   database.close();
// }
