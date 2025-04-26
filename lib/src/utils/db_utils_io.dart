import 'dart:io';

bool isNewDatabase(String dbPath) {
  final File file = File(dbPath);
  return !file.existsSync() || dbPath == ':memory:';
}
