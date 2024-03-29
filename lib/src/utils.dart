import 'dart:core' as core;
import 'dart:io';

import 'package:args/args.dart';

late ArgResults opts;

/// Print
void print(core.Object? object) {
  core.print('gitsumu: $object');
}

/// Print error
void ePrint(core.Object? object) {
  stderr.write('gitsumu error: $object\n');
}

/// Verbose print
void verbosePrint(core.Object? object) {
  if (opts['verbose']) {
    print(object);
  }
}
