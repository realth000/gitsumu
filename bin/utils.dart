import 'dart:io';

import 'package:args/args.dart';

late final ArgResults opts;

/// Print
void p(Object? object) {
  print('gitsumu: $object');
}

/// Print error
void e(Object? object) {
  stderr.write('gitsumu error: $object');
}

/// Verbose print
void vp(Object? object) {
  if (opts['verbose']) {
    p(object);
  }
}
