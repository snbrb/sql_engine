// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../sql_engine.dart';

/// Extract all `SqlSchema` annotations from the given [element].
/// Returns a sorted list of schemas by ascending version.
List<SqlSchema> extractSqlSchemas(ClassElement element) {
  final List<ConstantReader> schemaReaders = <ConstantReader>[];

  for (final ElementAnnotation metadata in element.metadata) {
    final DartObject? constantValue = metadata.computeConstantValue();
    if (constantValue == null) {
      continue;
    }

    final ConstantReader reader = ConstantReader(constantValue);
    if (reader.instanceOf(TypeChecker.fromRuntime(SqlSchema))) {
      schemaReaders.add(reader);
    }
  }

  final List<SqlSchema> schemas = <SqlSchema>[];
  for (final ConstantReader schemaReader in schemaReaders) {
    schemas.add(parseSqlSchema(schemaReader));
  }

  schemas.sort((SqlSchema a, SqlSchema b) => a.version.compareTo(b.version));
  return schemas;
}

/// Parse a single `SqlSchema` annotation into a runtime `SqlSchema` object.
SqlSchema parseSqlSchema(ConstantReader schemaReader) {
  final int version = schemaReader.read('version').intValue;
  final List<DartObject> columnList = schemaReader.read('columns').listValue;

  final List<SqlColumn> columns = <SqlColumn>[];
  for (final DartObject columnObj in columnList) {
    final ConstantReader colReader = ConstantReader(columnObj);

    final String accessor = colReader.read('type').revive().accessor;
    final SqlType sqlType = SqlType.fromAccessor(accessor);

    columns.add(
      SqlColumn(
        name: colReader.read('name').stringValue,
        type: sqlType,
        primaryKey: colReader.read('primaryKey').boolValue,
        autoincrement: colReader.read('autoincrement').boolValue,
        unique: colReader.read('unique').boolValue,
        nullable: colReader.read('nullable').boolValue,
        defaultValue: colReader.read('defaultValue').literalValue,
        references: colReader.read('references').literalValue?.toString(),
        referenceColumn:
            colReader.read('referenceColumn').literalValue?.toString(),
        renamedFrom: colReader.read('renamedFrom').literalValue?.toString(),
      ),
    );
  }

  // Parse seedData if provided
  final List<Map<String, Object?>> seedData = <Map<String, Object?>>[];

  for (final DartObject mapObj in schemaReader.read('seedData').listValue) {
    final Map<String, Object?> row = <String, Object?>{};
    final Map<DartObject?, DartObject?>? mapValues = mapObj.toMapValue();
    if (mapValues != null) {
      for (final MapEntry<DartObject?, DartObject?> entry
          in mapValues.entries) {
        final String? key = entry.key?.toStringValue();
        final Object? value =
            entry.value?.toStringValue() ??
            entry.value?.toIntValue() ??
            entry.value?.toBoolValue() ??
            entry.value?.toDoubleValue();
        if (key != null) {
          row[key] = value;
        }
      }
    }
    seedData.add(row);
  }

  return SqlSchema(version: version, columns: columns, seedData: seedData);
}
