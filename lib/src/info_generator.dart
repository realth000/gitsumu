import 'dart:async';

import 'package:build/build.dart';
import 'package:gitsumu/src/gitsumu.dart';
import 'package:gitsumu/src/info.dart';
import 'package:source_gen/source_gen.dart';

class InfoGenerator extends Generator {
  InfoGenerator(this.options);

  final BuilderOptions options;

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
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

    return formatInfo(
      buildStep.inputId.path,
      buildStep.allowedOutputs.single.path,
      revisionShort,
      revisionLong,
      flutterInfo,
      gitCommitTimeInfo,
      dartVersion,
    );
  }
}
