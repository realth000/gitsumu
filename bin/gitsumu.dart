import 'dart:io';

import 'package:args/args.dart';
import 'package:build_config/build_config.dart';
import 'package:collection/collection.dart';
import 'package:gitsumu/src/gitsumu.dart' as gitsumu;
import 'package:gitsumu/src/info.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'info.dart';
import 'utils.dart';

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

  final targetFile = infoBuilder.generateFor?.include;
  if (targetFile == null) {
    e('no include found, please add "generate_for" section to your config');
    exit(1);
  }
  if (targetFile.length != 1) {
    e('failed to generate: only support one file to generate info');
    exit(1);
  }

  // When using SharedPartBuilder and combining_builder, we should looks for extensions in combining_builder's option.
  final buildExtension = buildConfig
      .builders['source_gen:combining_builder']?.options['build_extensions'];

  // Actually we should do the same logic in lib/src/generate/expected_outputs.dart
  // But we do this in a lighter way which covers less conditions but still ok.
  String? outputPath;
  if (buildExtension != null && buildExtension is YamlMap) {
    for (final ext in buildExtension.keys) {
      if (!ext.contains('{{}}')) {
        // Plain text
        if (ext == targetFile.first) {
          outputPath = ext;
          break;
        }
        continue;
      }

      vp('targetFile: $targetFile');

      if (ext.indexOf('{{}}') != ext.lastIndexOf('{{}}')) {
        e('only support one catch group in "build_extensions" in config, exit');
        exit(1);
      }

      final re = RegExp(ext.replaceFirst('{{}}', r'([\w_\-/]*)'));
      // Get something like "^lib/{{}}.dart", check match our input "lib/zxc.dart"
      final allMatches = re.allMatches(targetFile.first).toList();
      if (allMatches.isEmpty) {
        // Not match our input, continue to next check.
        continue;
      }
      outputPath =
          buildExtension[ext]!.replaceFirst('{{}}', allMatches.first.group(1)!);
    }
  }

  // Fallback to default extension.
  outputPath ??= targetFile.first.replaceFirst('.dart', '.g.dart');

  vp('outputPath: $outputPath');

  // await buildInfo(targetFile.first, outputPath);

  p('generating info...');

  await generateInfo(targetFile.first, outputPath);

  p('generate info success');
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
