import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../../sql_engine.dart';

/// Extract all `SqlSchema` annotations from the given [element].
/// Returns a sorted list of schemas by ascending version.
// ignore: deprecated_member_use
List<SqlSchema> extractSqlSchemas(ClassElement element) {
  // Prepare a list to collect all matching SqlSchema annotations
  final List<ConstantReader> schemaReaders = <ConstantReader>[];

  // Loop through all annotations applied to the class
  for (final ElementAnnotation metadata in element.metadata) {
    // Compute the constant value of the annotation (evaluated form)
    final DartObject? constantValue = metadata.computeConstantValue();
    if (constantValue == null) {
      // Skip if the annotation couldn't be resolved (e.g., type mismatch or error)
      continue;
    }

    // Wrap the DartObject in a ConstantReader for safe property access
    final ConstantReader reader = ConstantReader(constantValue);

    // Check if this annotation is an instance of SqlSchema
    if (reader.instanceOf(TypeChecker.fromRuntime(SqlSchema))) {
      // Store the reader for later parsing
      schemaReaders.add(reader);
    }
  }

  // Convert the collected ConstantReaders into actual SqlSchema objects
  final List<SqlSchema> schemas = <SqlSchema>[];
  for (final ConstantReader schemaReader in schemaReaders) {
    // Parse each ConstantReader into a SqlSchema instance
    final SqlSchema schema = parseSqlSchema(schemaReader);
    schemas.add(schema);
  }

  // Sort schemas in ascending order by version to determine migration path
  schemas.sort((SqlSchema a, SqlSchema b) => a.version.compareTo(b.version));

  // Return the final ordered list of SqlSchema versions
  return schemas;
}

/// Parse a single `SqlSchema` annotation into a runtime `SqlSchema` object.
SqlSchema parseSqlSchema(ConstantReader schemaReader) {
  final int version = schemaReader.read('version').intValue;
  final List<DartObject> columnList = schemaReader.read('columns').listValue;

  final List<SqlColumn> columns = <SqlColumn>[];
  for (final DartObject columnObj in columnList) {
    final ConstantReader colReader = ConstantReader(columnObj);
    columns.add(
      SqlColumn(
        name: colReader.read('name').stringValue,
        type: colReader.read('type').literalValue?.toString(),
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

  return SqlSchema(version: version, columns: columns);
}
