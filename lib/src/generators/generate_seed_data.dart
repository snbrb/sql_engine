String generateSeedData(List<Map<String, dynamic>> seedData) {
  if (seedData.isEmpty) {
    return '<Map<String, dynamic>>[]';
  }

  final StringBuffer buffer = StringBuffer('<Map<String, dynamic>>[\n');

  for (final Map<String, dynamic> row in seedData) {
    buffer.write('    {');
    buffer.write(
      row.entries
          .map((MapEntry<String, dynamic> e) {
            final String key = "'${e.key}'";
            final String value = _dartLiteral(e.value);
            return '$key: $value';
          })
          .join(', '),
    );
    buffer.writeln('},');
  }

  buffer.write('  ]');
  return buffer.toString();
}

String _dartLiteral(dynamic value) {
  if (value == null) {
    return 'null';
  }
  if (value is String) {
    return "'${value.replaceAll("'", r"\'")}'";
  }
  if (value is bool || value is num) {
    return value.toString();
  }
  if (value is List<int>) {
    return '<int>[${value.join(', ')}]';
  }
  throw UnsupportedError('Unsupported seed value: $value');
}
