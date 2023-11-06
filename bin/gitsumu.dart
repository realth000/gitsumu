import 'dart:io';

import 'package:analyzer/dart/element/type.dart';
import 'package:args/args.dart';
import 'package:build_config/build_config.dart';
import 'package:collection/collection.dart';
import 'package:gitsumu/src/gitsumu.dart' as gitsumu;
import 'package:gitsumu/src/info.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

late final ArgResults opts;

Future<void> main(List<String> arguments) async {
  final parser = ArgParser();
  parser.addFlag('verbose', abbr: 'v', help: 'print more logs');
  opts = parser.parse(arguments);

  final buildConfig = await loadConfig();
  if (buildConfig == null) {
    e('empty build config, exit');
    exit(1);
  }

  final infoBuilder = buildConfig.builders['gitsumu:info'];
  if (infoBuilder == null) {
    vp('info builder not found, exit');
    exit(1);
  }

  if (!infoBuilder.isEnabled) {
    p('empty build config, skip');
    exit(0);
  }

  print(infoBuilder);
  final targetFile = infoBuilder.generateFor?.include;
  if (targetFile == null) {
    e('no include found, please add "generate_for" section to your config');
    exit(1);
  }
  if (targetFile.length != 1) {
    e('failed to generate: only support one file to generate info');
    exit(1);
  }
  final buildExtension = infoBuilder.options['build_extensions'];

  print(buildExtension.keys.first);

  // Actually we should do the same logic in lib/src/generate/expected_outputs.dart
  // But we do this in a lighter way which covers less conditions but still ok.
  String? outputPath;
  for (final ext in buildExtension.keys) {
    if (ext is! String) {
      continue;
    }
    if (!ext.contains('{{}}')) {
      // Plain text
      if (ext == targetFile.first) {
        outputPath = ext;
        break;
      }
      continue;
    }

    print('>>> target: $targetFile');

    if (ext.indexOf('{{}}') != ext.lastIndexOf('{{}')) {
      e('only support one catch group in "build_extensions" in config, exit');
      exit(1);
    }

    final re = RegExp(ext.replaceFirst('{{}}', '(\\w*)'));
    // Get something like "^lib/{{}}.dart", check match our input "lib/zxc.dart"
    final allMatches = re.allMatches(targetFile.first).toList();
    if (allMatches.isEmpty) {
      // Not match our input, continue to next check.
      continue;
    }
    outputPath =
        buildExtension[ext].replaceFirst('{{}}', allMatches.first.group(1)!);
  }

  outputPath ??= targetFile.first.replaceFirst('.dart', '.gitsumu.dart');

  print('>>> outputFileName: $outputPath');

  // await buildInfo(targetFile.first, outputPath);

  p('generating info...');

  final gitCommitTimeInfo = await gitsumu.getGitTime();
  if (gitCommitTimeInfo == null) {
    e('git time not found');
    exit(1);
  }

  final gitRevisionLong = await gitsumu.getGitRevisionLong();
  if (gitRevisionLong == null) {
    e('git revision long not found');
    exit(1);
  }
  vp('git revision long: $gitRevisionLong');

  final gitRevisionShort = await gitsumu.getGitRevisionShort();
  if (gitRevisionShort == null) {
    e('git revison short not found');
    exit(1);
  }
  vp('git revisioin short: $gitRevisionShort');

  final flutterInfo = await gitsumu.getFlutterVersion();
  if (flutterInfo == null) {
    e('flutter info not found');
    exit(1);
  }
  vp('flutter: $flutterInfo');

  final dartVersion = await gitsumu.getDartVersion();
  if (dartVersion == null) {
    e('dart info not found');
    exit(1);
  }
  vp('dart: $dartVersion');

  final outputData = formatInfo(
    targetFile.first,
    outputPath,
    gitRevisionShort,
    gitRevisionLong,
    flutterInfo,
    gitCommitTimeInfo,
    dartVersion,
  );

  vp('>>> output: $outputData');
  final outputFile = File(outputPath);
  if (!outputFile.existsSync()) {
    await outputFile.create();
  }
  await outputFile.writeAsString(outputData);
}

Future<BuildTarget?> loadConfig() async {
  final configFile = Directory.current
      .listSync()
      .whereType<File>()
      .firstWhereOrNull((e) => path.basename(e.path) == 'build.yaml');
  if (configFile == null) {
    e('config file not found. Please run this command in the same directory with "build.yaml" or configure "build.yaml" in this directory');
    exit(1);
  }
  final configMap =
      BuildConfig.parse('gitsumu', [], await configFile.readAsString());
  return configMap.buildTargets['gitsumu:gitsumu'];
}

/// Print
void p(Object? object) {
  print('gitsumu: $object');
}

void e(Object? object) {
  print('gitsumu error: $object');
}

/// Verbose print
void vp(Object? object) {
  if (opts['verbose']) {
    p(object);
  }
}
