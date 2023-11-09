import 'dart:async';
import 'dart:io';

import 'package:gitsumu/src/gitsumu.dart' as gitsumu;
import 'package:gitsumu/src/info.dart';
import 'package:path/path.dart' as path;

import 'utils.dart';

Future<void> generateInfo(String inputPath, String outputPath) async {
  final gitCommitTimeInfo = await gitsumu.getGitTime();
  if (gitCommitTimeInfo == null) {
    ePrint('git time not found');
    exit(1);
  }

  final gitRevisionLong = await gitsumu.getGitRevisionLong();
  if (gitRevisionLong == null) {
    ePrint('git revision long not found');
    exit(1);
  }
  verbosePrint('git revision long: $gitRevisionLong');

  final gitRevisionShort = await gitsumu.getGitRevisionShort();
  if (gitRevisionShort == null) {
    ePrint('git revision short not found');
    exit(1);
  }
  verbosePrint('git revision short: $gitRevisionShort');

  final flutterInfo = await gitsumu.getFlutterVersion();
  if (flutterInfo == null) {
    ePrint('flutter info not found');
    exit(1);
  }
  verbosePrint('flutter: $flutterInfo');

  final dartVersion = await gitsumu.getDartVersion();
  if (dartVersion == null) {
    ePrint('dart info not found');
    exit(1);
  }
  verbosePrint('dart: $dartVersion');

  final code = formatInfo(
    gitRevisionShort,
    gitRevisionLong,
    flutterInfo,
    gitCommitTimeInfo,
    dartVersion,
  );

  // Copied from source_gen package function uriOfPartial().
  final sourceFilePath =
      path.url.relative(inputPath, from: path.url.dirname(outputPath));

  final outputData = '''
part of '$sourceFilePath';

$code
''';

  verbosePrint('output: $outputData');
  final outputFile = File(outputPath);
  if (!outputFile.parent.existsSync()) {
    await outputFile.parent.create(recursive: true);
  }
  await outputFile.writeAsString(outputData);
}
