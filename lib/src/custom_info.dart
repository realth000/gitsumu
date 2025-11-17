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
  String outputPath,
) async {
  late final CustomInfoPlatforms currentPlatform;
  if (Platform.isLinux) {
    currentPlatform = CustomInfoPlatforms.linux;
  } else if (Platform.isWindows) {
    currentPlatform = CustomInfoPlatforms.windows;
  } else if (Platform.isMacOS) {
    currentPlatform = CustomInfoPlatforms.macos;
  } else {
    ePrint('custom command is unavailable on current platform');
    exit(1);
  }

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

  // Stores all generated custom command.
  // Keys is ${annotation.name}, value is generated text.
  //
  // Reserve info and used to remove duplicate result came from build cache.
  final resultList = <String, String>{};

  final element = resolvedUnit.unit;
  for (final d in element.declarations) {
    // Only support parsing commands from top level variables.
    if (d is! TopLevelVariableDeclaration) {
      continue;
    }

    // Find annotation.
    final annotation = d.metadata.firstWhereOrNull((e) => e.name.name == 'CustomInfo')?.parseToCustomInfo();
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
    //
    // Package analyzer use `withNullability` as required parameter before 6.5.0
    // but marked deprecated since 6.5.0.
    final variableType = variable.declaredFragment?.element.constantInitializer?.staticType?.getDisplayString();
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
    final commandAndArgs =
        variable.initializer!.childEntities.whereType<StringLiteral>().map((e) => e.stringValue!).toList();

    if (!annotation.platforms.contains(currentPlatform)) {
      // Current platform not enabled.
      if (annotation.platformDefaultValue != null) {
        // Have default value.
        verbosePrint(
            'command $commandAndArgs use default value which is not enabled on current platform $currentPlatform');
        resultList[annotation.name] = "\n// @@start@@ ${annotation.name}\n"
            "const ${annotation.name} = r'''${annotation.platformDefaultValue}''';\n"
            "// @@end@@ ${annotation.name}";
        continue;
      }
      // Do nothing if when both platform not enabled and default value not set.
      continue;
    }

    verbosePrint('run command: $commandAndArgs');

    final command = commandAndArgs.removeAt(0);

    final (out, err) = await gitsumu.runCommand(command, commandAndArgs);
    if (err.isNotEmpty && !annotation.ignoreStderr && !annotation.useStderr) {
      ePrint('error running command "$command $commandAndArgs": $err');
      exit(1);
    }

    final commandResult = annotation.useStderr ? err.trim() : out.trim();
    // Use ''' to allow multiple lines.
    resultList[annotation.name] = "\n// @@start@@ ${annotation.name}\n"
        "const ${annotation.name} = r'''$commandResult''';\n"
        "// @@end@@ ${annotation.name}";
  }

  final outputData = resultList.values.join('\n');
  final outputFile = File(outputPath);

  // Here we strip duplicate generated variables which came from build cache.
  //
  // For some reason, build_runner is caching file output in this generator and prepend those
  // cached data into output file just before running the custom builder.
  // This results in duplicate variables definitions which become annoying compile time error.
  //
  // So remove those data by checking for the start line and end line prepend/append to generated
  // code:
  //
  // ```dart
  // // @@start@@ ${annotation.name}
  // generated code here
  // // @@end@@ ${annotation.name}
  // ```
  if (outputFile.existsSync()) {
    verbosePrint('output file exsits, stripping outdated custom variables came from build cache...');
    final oldLines = await outputFile.readAsLines();
    final reservedLines = <String>[];
    bool skipping = false;
    for (final line in oldLines) {
      if (line.startsWith('// @@end@@ ') && skipping) {
        verbosePrint('[strip] end skipping on line "$line"');
        skipping = false;
        continue;
      } else if (line.startsWith('// @@start@@ ') && !skipping) {
        verbosePrint('[strip] start skipping on line "$line"');
        skipping = true;
        continue;
      }
      if (skipping) {
        continue;
      }

      reservedLines.add(line);
    }

    await outputFile.writeAsString(reservedLines.join('\n'));
  }

  await outputFile.writeAsString(outputData, mode: FileMode.append);

  return null;
}

String? _getCurrentProjectRootDirectory() {
  Directory directory = Directory.current;
  int count = 5;
  while (count > 0) {
    if (directory.listSync(recursive: false).firstWhereOrNull((e) => path.basename(e.path) == 'pubspec.yaml') != null) {
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
    final platforms = <CustomInfoPlatforms>{};
    String? platformDefaultValue;

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
          case 'platforms':
            platforms.addAll(_parsePlatformList(arg));
          case 'platformDefaultValue':
            platformDefaultValue = (arg.expression as StringLiteral).stringValue;
        }
      }
    }

    if (platforms.isEmpty) {
      // Set with default values.
      platforms.addAll({
        CustomInfoPlatforms.linux,
        CustomInfoPlatforms.macos,
        CustomInfoPlatforms.windows,
      });
    }

    if (name == null) {
      return null;
    }
    return CustomInfo(
      name,
      ignoreStderr: ignoreStderr,
      useStderr: useStderr,
      platforms: platforms,
      platformDefaultValue: platformDefaultValue,
    );
  }

  Set<CustomInfoPlatforms> _parsePlatformList(
    NamedExpression namedExpression,
  ) {
    final ret = <CustomInfoPlatforms>{};
    final platformList = (namedExpression.expression as SetOrMapLiteral)
        .elements
        .where((e) => (e as Expression).staticType.toString() == "CustomInfoPlatforms")
        .map((e) => (e as PrefixedIdentifier).identifier.toString())
        .toList();

    for (final platform in platformList) {
      switch (platform) {
        case "linux":
          ret.add(CustomInfoPlatforms.linux);
        case "macos":
          ret.add(CustomInfoPlatforms.macos);
        case "windows":
          ret.add(CustomInfoPlatforms.windows);
      }
    }

    return ret;
  }
}
