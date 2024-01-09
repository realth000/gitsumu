import 'dart:async';

import 'package:args/args.dart';
import 'package:build/build.dart';
import 'package:gitsumu/src/custom_info.dart';
import 'package:gitsumu/src/entry.dart';
import 'package:gitsumu/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class CustomInfoGenerator extends Generator {
  CustomInfoGenerator(this.options);

  final BuilderOptions options;
  static bool _generated = false;

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    if (_generated) {
      return null;
    }

    _generated = true;

    final parser = ArgParser();
    parser.addFlag('verbose', abbr: 'v', help: 'print more logs');
    opts = parser.parse([]);
    final (inputPath, outputPath) = await parsePath();

    return generateCustomInfo(inputPath, outputPath);
  }
}
