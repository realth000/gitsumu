import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:collection/collection.dart';
import 'package:gitsumu/src/gitsumu.dart' as gitsumu;
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
    // Only support parsing commands from top level variables.
    if (d is! TopLevelVariableDeclaration) {
      continue;
    }

    // Find annotation.
    final annotation =
        d.metadata.firstWhereOrNull((e) => e.name.name == 'customInfo');
    if (annotation == null) {
      continue;
    }

    // Currently only find the very first variable.
    final variable = d.variables.variables.firstOrNull;
    if (variable == null) {
      continue;
    }

    verbosePrint('get variable: $variable');

    // Variable type should be list of string.
    final variableType =
        variable.declaredElement?.type.getDisplayString(withNullability: true);
    if (variableType != 'List<String>') {
      ePrint(
        'only support declaring custom commands using List<String>, got $variableType',
      );
      exit(1);
    }

    // Check initializer, likely this will not be null, but still check it to
    // make compiler happy.
    if (variable.initializer == null) {
      ePrint('failed to get initializer for command $d');
      exit(1);
    }

    // Here we get command and all arguments for it in a list.
    // The first element in list is command, and other elements are arguments,
    // may exist or not.
    final commandAndArgs = variable.initializer!.childEntities
        .whereType<StringLiteral>()
        .map((e) => e.stringValue!)
        .toList();

    verbosePrint('get command and args: $commandAndArgs');

    final command = commandAndArgs.removeAt(0);

    final (out, err) = await gitsumu.runCommand(command, commandAndArgs);
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
