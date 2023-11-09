import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class CustomInfoGenerator extends Generator {
  CustomInfoGenerator(this.options);

  final BuilderOptions options;

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    return '';
  }
}
