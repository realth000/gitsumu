import 'dart:async';

import 'package:build/build.dart';
import 'package:gitsumu/src/gitsumu.dart';
import 'package:path/path.dart' as path;
import 'package:source_gen/source_gen.dart';

class InfoGenerator extends Generator {
  InfoGenerator(this.options);

  final BuilderOptions options;

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    // Copied from source_gen package function uriOfPartial().
    final sourceFilePath = path.url.relative(buildStep.inputId.path,
        from: path.url.dirname(buildStep.allowedOutputs.single.path));

    final gitCommitTimeInfo = await getGitTime();
    if (gitCommitTimeInfo == null) {
      return null;
    }
    // print(timeLong);

    final revisionLong = await getGitRevisionLong();
    if (revisionLong == null) {
      return null;
    }
    // print(revisionLong);

    final revisionShort = await getGitRevisionShort();
    if (revisionShort == null) {
      return null;
    }
    // print(revisionShort);

    final flutterInfo = await getFlutterVersion();
    if (flutterInfo == null) {
      return null;
    }

    final dartVersion = await getDartVersion();
    if (dartVersion == null) {
      return null;
    }

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
}
