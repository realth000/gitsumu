library gitsumu.builder;

import 'package:build/build.dart';
import 'package:gitsumu/src/info_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder infoBuilder(BuilderOptions options) => LibraryBuilder(
      InfoGenerator(),
      options: options,
    );
