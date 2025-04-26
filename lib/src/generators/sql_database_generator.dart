import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../../sql_engine.dart';
import 'generate_app_database_class.dart';

class SqlDatabaseGenerator extends GeneratorForAnnotation<SqlDatabase> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@SqlDatabase can only be applied to a class.',
        element: element,
      );
    }

    final String dbClassName = element.name;
    final int version = annotation.read('version').intValue;

    final List<String> models =
        annotation
            .read('models')
            .listValue
            .map((DartObject v) => v.toTypeValue()!.getDisplayString())
            .toList();

    final String tableList = models
        .map((String m) => '${m}Table()')
        .join(',\n    ');
    final String migrationList = models
        .map((String m) => '...${m}Table.migrations')
        .join(',\n    ');

    return generateAppDatabaseClass(
      dbClassName: dbClassName,
      version: version,
      tableList: tableList,
      migrationList: migrationList,
    );
  }

  String _toCamel(String input) => input[0].toLowerCase() + input.substring(1);
}
