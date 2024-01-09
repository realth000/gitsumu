import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:collection/collection.dart';
import 'package:gitsumu/annotation.dart';
import 'package:gitsumu/src/gitsumu.dart' as gitsumu;
import 'package:path/path.dart' as path;

import 'utils.dart';

// https://stackoverflow.com/questions/53111056/dart-analyzer-sources-needing-processing
Future<String?> generateCustomInfo(
  String inputPath,
  String outputPath, {
  bool saveToFile = true,
}) async {
  final projectRootDir = _getCurrentProjectRootDirectory();
  if (projectRootDir == null) {
    ePrint('failed to find root directory of current project\n'
        'this command should run in project directory');
    exit(1);
  }

  String filePath = '$projectRootDir/$inputPath';
  if (Platform.isWindows) {
    filePath = filePath.replaceAll('/', '\\');
  }

  final collection = AnalysisContextCollection(
    includedPaths: [filePath],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  final context = collection.contextFor(filePath);
  final resolvedUnit = await context.currentSession.getResolvedUnit(filePath);
  if (resolvedUnit is! ResolvedUnitResult) {
    throw Exception('failed to parse $filePath: ${resolvedUnit.runtimeType}');
  }

  final resultList = <String>[];

  final element = resolvedUnit.unit;
  for (final d in element.declarations) {
    // Only support parsing commands from top level variables.
    if (d is! TopLevelVariableDeclaration) {
      continue;
    }

    // Find annotation.
    final annotation = d.metadata
        .firstWhereOrNull((e) => e.name.name == 'CustomInfo')
        ?.parseToCustomInfo();
    if (annotation == null) {
      ePrint('failed to parse for $d');
      continue;
    }

    verbosePrint('annotation: $annotation');

    // Currently only find the very first variable.
    final variable = d.variables.variables.firstOrNull;
    if (variable == null) {
      continue;
    }

    verbosePrint('variable: $variable');

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

    verbosePrint('run command: $commandAndArgs');

    final command = commandAndArgs.removeAt(0);

    final (out, err) = await gitsumu.runCommand(command, commandAndArgs);
    if (err.isNotEmpty && !annotation.ignoreStderr && !annotation.useStderr) {
      ePrint('error running command "$command $commandAndArgs": $err');
      exit(1);
    }

    final commandResult = annotation.useStderr ? err.trim() : out.trim();
    // Use ''' to allow multiple lines.
    resultList.add("const ${annotation.name} = '''$commandResult''';");
  }

  if (!saveToFile) {
    return resultList.join('\n');
  }

  final outputData = '''
// Custom info
${resultList.join('\n')}
''';
  final outputFile = File(outputPath);
  outputFile.writeAsString(outputData, mode: FileMode.append);

  return null;
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

extension ParseCustomInfo on Annotation {
  CustomInfo? parseToCustomInfo() {
    String? name;
    bool ignoreStderr = false;
    bool useStderr = false;

    for (final arg in arguments!.arguments) {
      // Name only.
      if (arg is SimpleStringLiteral) {
        name = arg.value;
      }

      // Key value pair for named arguments.
      // These types are checked by compiler, just convert and use them.
      if (arg is NamedExpression) {
        switch (arg.name.label.toString()) {
          case 'ignoreStderr':
            ignoreStderr = (arg.expression as BooleanLiteral).value;
          case 'useStderr':
            useStderr = (arg.expression as BooleanLiteral).value;
        }
      }
    }

    if (name == null) {
      return null;
    }
    return CustomInfo(name, ignoreStderr: ignoreStderr, useStderr: useStderr);
  }
}
