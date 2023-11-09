import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import 'utils.dart';

// https://stackoverflow.com/questions/53111056/dart-analyzer-sources-needing-processing
Future<void> generateCustomInfo(String inputPath) async {
  final projectRootDir = _getCurrentProjectRootDirectory();
  if (projectRootDir == null) {
    ePrint('failed to find root directory of current project\n'
        'this command should run in project directory');
    exit(1);
  }

  final filePath = '$projectRootDir/$inputPath';

  final collection = AnalysisContextCollection(
    includedPaths: [filePath],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  final context = collection.contextFor(filePath);
  final resolvedUnit = await context.currentSession.getResolvedUnit(filePath);
  if (resolvedUnit is! ResolvedUnitResult) {
    throw Exception('failed to parse $filePath: ${resolvedUnit.runtimeType}');
  }
  final element = resolvedUnit.unit;
  for (final d in element.declarations) {
    if (d is! TopLevelVariableDeclaration) {
      continue;
    }
    print('${d} ${d.metadata}');
  }
}

String? _getCurrentProjectRootDirectory() {
  Directory directory = Directory.current;
  int count = 5;
  while (count > 0) {
    if (directory
            .listSync(recursive: false)
            .firstWhereOrNull((e) => path.basename(e.path) == 'pubspec.yaml') !=
        null) {
      return directory.path;
    }
    directory = directory.parent;
    count = count - 1;
  }
  return null;
}
