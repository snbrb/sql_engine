import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generators/sql_database_generator.dart';
import 'src/generators/sql_engine_generator.dart';

/// Instance of [SharedPartBuilder] that executes the [DataModelGenerator] and
/// returns a part of a generated file.
Builder sqlEngineBuilder(BuilderOptions options) => PartBuilder(
  <Generator>[
    SqlEngineGenerator(),
    SqlDatabaseGenerator(),
    //
  ],

  //this id is very important! When generating the output, the build system
  //might produce multiple "parts" and then once done combine them into one.
  //this allows multiple annotations to run on a class. The id we provide
  //here unique isolates other generated "parts". So generally name it to
  //match your package name!
  '.g.dart', //generated/.mapped_database.g.dart//.mapped_database.g.dart
  header: '''
          // GENERATED CODE - DO NOT MODIFY BY HAND
          // ignore_for_file: type=lint, unnecessary_brace_in_string_interps,  unused_element, unnecessary_null_comparison, unnecessary_cast, invalid_null_aware_operator
    ''',
);
