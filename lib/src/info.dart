import 'package:gitsumu/src/gitsumu.dart';

String formatInfo(
  String revisionShort,
  String revisionLong,
  FlutterInfo flutterInfo,
  GitCommitTimeInfo gitCommitTimeInfo,
  String dartVersion,
) {
  final data = '''
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
const gitCommitTimeYMDHMS  = '${gitCommitTimeInfo.year}-${gitCommitTimeInfo.month}-${gitCommitTimeInfo.day} ${gitCommitTimeInfo.hour}:${gitCommitTimeInfo.minute}:${gitCommitTimeInfo.second}';
const gitCommitTimeTimezone  = '${gitCommitTimeInfo.timeZone}';
const gitCommitRevisionLong  = '$revisionLong';
const gitCommitRevisionShort = '$revisionShort';
''';

  return data;
}
