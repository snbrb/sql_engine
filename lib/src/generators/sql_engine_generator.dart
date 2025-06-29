// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../../sql_engine.dart';

import 'extract_sql_create_table_query.dart';
import 'extract_sql_indexes.dart';
import 'extract_sql_schema.dart';
import 'generate_index_statement.dart';
import 'generate_migrations.dart';
import 'generate_sql_engine_table_class.dart';

/// Generates a class that extends `SqlEngineTable` from `@SqlTable`.
class SqlEngineGenerator extends GeneratorForAnnotation<SqlTable> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    // 1) Ensure this is used on a class.
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'The @SqlTable annotation can only be applied to a class.',
        element: element,
      );
    }

    final ClassElement classElement = element;
    final String className = classElement.name;
    final String tableName = annotation.read('tableName').stringValue;
    final bool softDelete = annotation.read('softDelete').boolValue;

    //final int version = annotation.read('version').intValue;

    // 2) Get all schema versions.
    final List<SqlSchema> schemas = extractSqlSchemas(classElement);

    if (schemas.isEmpty) {
      throw InvalidGenerationSourceError(
        'No @SqlSchema found for class $className.',
        element: classElement,
      );
    }

    // 3) Use the latest version's schema
    final SqlSchema latest = schemas.last;
    final String createSql = extractSqlCreateTableQuery(tableName, latest);

    final List<SqlEngineMigration> migrations = generateMigrations(
      tableName,
      schemas,
    );

    final List<SqlColumn> columns = latest.columns;

    // ✅ Validate `deleted_at` presence if softDelete is true
    if (softDelete) {
      final bool hasDeletedAt = columns.any(
        (SqlColumn c) => c.name == 'deleted_at',
      );
      if (!hasDeletedAt) {
        throw InvalidGenerationSourceError(
          'Table "$tableName" is marked with softDelete: true, '
          'but is missing a "deleted_at" column.',
          element: classElement,
        );
      }
    }

    // handle indexes
    final List<SqlIndex> indexes = extractSqlIndexes(classElement);
    final List<String> createIndexes = generateIndexStatements(
      tableName,
      indexes,
    );

    // 4) Generate Dart class with SQL string

    final String output = generateSqlEngineTableClass(
      originalClassName: className,
      tableName: tableName,
      createTableSql: createSql,
      migrations: migrations,
      columns: columns,
      schemas: schemas,
      createIndexes: createIndexes,
      softDelete: softDelete,
    );

    return output;
  }
}
