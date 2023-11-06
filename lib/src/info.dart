import 'package:gitsumu/src/gitsumu.dart';
import 'package:path/path.dart' as path;

String formatInfo(
  String inputPath,
  String outputPath,
  String revisionShort,
  String revisionLong,
  FlutterInfo flutterInfo,
  GitCommitTimeInfo gitCommitTimeInfo,
  String dartVersion,
) {
  // Copied from source_gen package function uriOfPartial().
  final sourceFilePath = path.url.relative(inputPath,
      from: path.url.dirname(outputPath));

  final data = '''
part of '$sourceFilePath';

// Compile environment
const flutterVersion         = '${flutterInfo.version}';
const flutterChannel         = '${flutterInfo.channel}';
const flutterFrameworkRevision  = '${flutterInfo.frameworkRevision}';
const flutterFrameworkTimestamp = '${flutterInfo.frameworkTimestamp}';
const flutterEngineRevision  = '${flutterInfo.engineRevision}';
const flutterDartVersion     = '${flutterInfo.dartVersion}';
const flutterDevToolsVersion = '${flutterInfo.devToolsVersion}';
const dartVersion            = '$dartVersion';

// Repo info
const gitCommitTimeYear      = '${gitCommitTimeInfo.year}';
const gitCommitTimeMonth     = '${gitCommitTimeInfo.month}';
const gitCommitTimeDay       = '${gitCommitTimeInfo.day}';
const gitCommitTimeHour      = '${gitCommitTimeInfo.hour}';
const gitCommitTimeMinute    = '${gitCommitTimeInfo.minute}';
const gitCommitTimeSecond    = '${gitCommitTimeInfo.second}';
const gitCommitTimeTimezone  = '${gitCommitTimeInfo.timeZone}';
const gitCommitRevisionLong  = '$revisionLong';
const gitCommitRevisionShort = '$revisionShort';
''';

  return data;
}