import 'dart:async';
import 'dart:io';

import 'package:gitsumu/src/gitsumu.dart' as gitsumu;
import 'package:gitsumu/src/gitsumu.dart';
import 'package:gitsumu/src/utils.dart';
import 'package:path/path.dart' as path;

String formatInfo(
  String revisionShort,
  String revisionLong,
  String commitCountRepo,
  String commitCountCurrentBranch,
  FlutterInfo? flutterInfo,
  GitCommitTimeInfo gitCommitTimeInfo,
  String dartVersion,
  AppInfo appInfo,
) {
  // Allow null flutter info in case of pure dart environment.
  final flutterInfoStr = flutterInfo == null
      ? ''
      : '''
const flutterVersion         = '${flutterInfo.version}';
const flutterChannel         = '${flutterInfo.channel}';
const flutterFrameworkRevision  = '${flutterInfo.frameworkRevision}';
const flutterFrameworkTimestamp = '${flutterInfo.frameworkTimestamp}';
const flutterEngineRevision  = '${flutterInfo.engineRevision}';
const flutterDartVersion     = '${flutterInfo.dartVersion}';
const flutterDevToolsVersion = '${flutterInfo.devToolsVersion}';
''';

  final data = '''
// Compile environment
$flutterInfoStr
const dartVersion            = '$dartVersion';

// Repo info
const gitCommitTimeYear      = '${gitCommitTimeInfo.year}';
const gitCommitTimeMonth     = '${gitCommitTimeInfo.month}';
const gitCommitTimeDay       = '${gitCommitTimeInfo.day}';
const gitCommitTimeHour      = '${gitCommitTimeInfo.hour}';
const gitCommitTimeMinute    = '${gitCommitTimeInfo.minute}';
const gitCommitTimeSecond    = '${gitCommitTimeInfo.second}';
const gitCommitTimeYMDHMS  = '${gitCommitTimeInfo.year}-${gitCommitTimeInfo.month}-${gitCommitTimeInfo.day} ${gitCommitTimeInfo.hour}:${gitCommitTimeInfo.minute}:${gitCommitTimeInfo.second}';
const gitCommitTimeTimezone  = '${gitCommitTimeInfo.timeZone}';
const gitCommitRevisionLong  = '$revisionLong';
const gitCommitRevisionShort = '$revisionShort';
@Deprecated('gitCommitCount was mistakenly implemented to count total commits from all branches in repo, causing a misleading meaning and should not be used anymore.\\n'
'Use these alternatives instead:\\n'
'1. To get commits count in repo as what it did before, use gitCommitCountRepo\\n'
'2. To get commits count on current branch, use gitCommitCountCurrentBranch')
const gitCommitCount         = '$commitCountRepo';
const gitCommitCountRepo          = '$commitCountRepo';
const gitCommitCountCurrentBranch = '$commitCountCurrentBranch';

// App info
const appName        = '${appInfo.name}';
const appDescription = '${appInfo.description}';
const appVersion     = '${appInfo.version}';
''';

  return data;
}

Future<String?> generateInfo(
  String inputPath,
  String outputPath, {
  bool saveToFile = true,
}) async {
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

  final gitCommitCountRepo = await gitsumu.getGitCommitCountRepo();
  if (gitCommitCountRepo == null) {
    ePrint('git commit count repo not found');
    exit(1);
  }
  verbosePrint('git commit count repo: $gitCommitCountRepo');

  final gitCommitCountCurrentBranch =
      await gitsumu.getGitCommitCountCurrentBranch();
  if (gitCommitCountCurrentBranch == null) {
    ePrint('git commit count current branch not found');
    exit(1);
  }
  verbosePrint('git commit count current branch: $gitCommitCountCurrentBranch');

  final flutterInfo = await gitsumu.getFlutterVersion();
  if (flutterInfo == null) {
    print('flutter info not found');
  }
  verbosePrint('flutter: $flutterInfo');

  final dartVersion = await gitsumu.getDartVersion();
  if (dartVersion == null) {
    ePrint('dart info not found');
    exit(1);
  }
  verbosePrint('dart: $dartVersion');

  final appVersion = await gitsumu.getAppInfo();
  if (appVersion == null) {
    ePrint('app version not found');
    exit(1);
  }
  verbosePrint('app version: $appVersion');

  final code = formatInfo(
    gitRevisionShort,
    gitRevisionLong,
    gitCommitCountRepo,
    gitCommitCountCurrentBranch,
    flutterInfo,
    gitCommitTimeInfo,
    dartVersion,
    appVersion,
  );

  if (!saveToFile) {
    return code;
  }

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

  return null;
}
