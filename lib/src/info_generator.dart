import 'dart:async';

import 'package:build/build.dart';
import 'package:gitsumu/gitsumu.dart';
import 'package:source_gen/source_gen.dart';

class InfoGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    // Source code file path if "part of" statement.
    // Usually the path here is "lib/xxx/xxx.dart", use absolute path"/xxx/xxx.dart"
    // to make sure "part" and "part of" works.
    final sourceFilePath = buildStep.inputId.path.replaceFirst('lib', '');
    final timeLong = await getGitTimeLong();
    if (timeLong == null) {
      return null;
    }
    // print(timeLong);

    final timeShort = await getGitTimeShort();
    if (timeShort == null) {
      return null;
    }
    // print(timeShort);

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

    final flutterVersion = await getFlutterVersion();
    if (flutterVersion == null) {
      return null;
    }

    final dartVersion = await getDartVersion();
    if (dartVersion == null) {
      return null;
    }

    final data = '''
part of '$sourceFilePath';

// Compile environment
const flutterVersion         = '$flutterVersion';
const dartVersion            = '$dartVersion';

// Repo info
const gitCommitTimeLong      = '$timeLong';
const gitCommitTimeShort     = '$timeShort';
const gitCommitRevisionLong  = '$revisionLong';
const gitCommitRevisionShort = '$revisionShort';
''';

    return data;
  }
}
