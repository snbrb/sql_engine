// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations/sql_index.dart';

List<SqlIndex> extractSqlIndexes(ClassElement element) {
  final List<SqlIndex> indexes = <SqlIndex>[];

  for (final ElementAnnotation metadata in element.metadata) {
    final DartObject? constantValue = metadata.computeConstantValue();
    if (constantValue == null) {
      // Skip if the annotation couldn't be resolved (e.g., type mismatch or error)
      continue;
    }

    // Wrap the DartObject in a ConstantReader for safe property access
    final ConstantReader reader = ConstantReader(constantValue);

    // Check if this annotation is an instance of SqlSchema
    if (reader.instanceOf(TypeChecker.fromRuntime(SqlIndex))) {
      final String name = reader.read('name').stringValue;
      final List<String> columns =
          reader
              .read('columns')
              .listValue
              .map((DartObject col) => col.toStringValue()!)
              .toList();
      indexes.add(SqlIndex(name: name, columns: columns));
    }
  }

  return indexes;
}
