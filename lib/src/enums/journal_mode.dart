enum JournalMode {
  delete('DELETE'),
  truncate('TRUNCATE'),
  persist('PERSIST'),
  memory('MEMORY'),
  wal('WAL'),
  off('OFF');

  final String sqlValue;

  const JournalMode(this.sqlValue);

  @override
  String toString() => sqlValue;
}
