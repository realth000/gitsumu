import 'dart:async';

import 'package:args/args.dart';
import 'package:build/build.dart';
import 'package:gitsumu/src/entry.dart';
import 'package:gitsumu/src/info.dart';
import 'package:gitsumu/src/utils.dart';
import 'package:source_gen/source_gen.dart';

class InfoGenerator extends Generator {
  InfoGenerator(this.options);

  final BuilderOptions options;

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final parser = ArgParser();
    parser.addFlag('verbose', abbr: 'v', help: 'print more logs');
    opts = parser.parse([]);
    final (inputPath, outputPath) = await parsePath();

    return generateInfo(inputPath, outputPath);
  }
}
