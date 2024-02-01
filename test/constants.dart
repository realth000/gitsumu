const buildConfig = ''' 
targets:
  \$default:
    builders:
      gitsumu|info:
        generate_for:
          - lib/example.dart
''';
const buildConfigWithExt = '''
targets:
  \$default:
    builders:
      source_gen|combining_builder:
        options:
          build_extensions:
            '^lib/{{}}.dart': 'lib/generated/{{}}.g.dart'
      gitsumu|info:
        generate_for:
          - lib/utils/git_info.dart
''';

const code = '''
import 'dart:io';

import 'package:gitsumu/annotation.dart';

part "example.g.dart";

void main(List<String> args) {
  switch (args.first) {
    case 'gitRevisionLong':
      print(gitCommitRevisionLong);
    case 'customInfo':
      print(myCommandResult);
    case 'customInfo2':
      print(myCommandResult2);
    case 'customFromStderr':
      print(myCommandFromStderr);
    case 'customInfo3':
      print(myCommandResult3);
    case 'customInfo4':
      print(myCommandResult4);
    case 'customInfo5':
      print(myCommandResult5);
    default:
      throw Exception('Unrecognized test info parameter "\${args.first}"');
  }
}

@CustomInfo('myCommandResult')
const aNotImportantName = ['dart', '--help'];

@CustomInfo('myCommandResult2', ignoreStderr: true)
const alsoNotImportantName = ['git', 'checkout', '123456789'];

@CustomInfo('myCommandFromStderr', useStderr: true)
const alsoNotImportantName2 = ['git', 'abc'];

@CustomInfo(
  'myCommandResult3',
  platforms: {CustomInfoPlatforms.linux},
  platformDefaultValue: 'default_not_linux',
)
const alsoNotImportantName3 = ['hostname'];

@CustomInfo(
  'myCommandResult4',
  platforms: {CustomInfoPlatforms.macos},
  platformDefaultValue: 'default_not_macos',
)
const alsoNotImportantName4 = ['hostname'];

@CustomInfo(
  'myCommandResult5',
  platforms: {CustomInfoPlatforms.windows},
  platformDefaultValue: 'default_not_windows',
)
const alsoNotImportantName5 = ['hostname'];
''';

const codeWithExt = '''
import 'dart:io';

import 'package:gitsumu/annotation.dart';

part "../generated/utils/git_info.g.dart";

void main(List<String> args) {
  switch (args.first) {
    case 'gitRevisionLong':
      print(gitCommitRevisionLong);
    case 'customInfo':
      print(myCommandResult);
    case 'customInfo2':
      print(myCommandResult2);
    case 'customFromStderr':
      print(myCommandFromStderr);
    case 'customInfo3':
      print(myCommandResult3);
    case 'customInfo4':
      print(myCommandResult4);
    case 'customInfo5':
      print(myCommandResult5);
    default:
      throw Exception('Unrecognized test info parameter "\${args.first}"');
  }
}

@CustomInfo('myCommandResult')
const aNotImportantName = ['dart', '--help'];

@CustomInfo('myCommandResult2', ignoreStderr: true)
const alsoNotImportantName = ['git', 'checkout', '123456789'];

@CustomInfo('myCommandFromStderr', useStderr: true)
const alsoNotImportantName2 = ['git', 'abc'];

@CustomInfo(
  'myCommandResult3',
  platforms: {CustomInfoPlatforms.linux},
  platformDefaultValue: 'default_not_linux',
)
const alsoNotImportantName3 = ['hostname'];

@CustomInfo(
  'myCommandResult4',
  platforms: {CustomInfoPlatforms.macos},
  platformDefaultValue: 'default_not_macos',
)
const alsoNotImportantName4 = ['hostname'];

@CustomInfo(
  'myCommandResult5',
  platforms: {CustomInfoPlatforms.windows},
  platformDefaultValue: 'default_not_windows',
)
const alsoNotImportantName5 = ['hostname'];
''';

const gitRef = '.git/refs/heads/master';

const codePath = 'lib/example.dart';
const genCodePath = 'lib/example.g.dart';
const exePath = 'lib/example.exe';

const utilCodePath = 'lib/utils/git_info.dart';
const utilGenCodePath = 'lib/generated/utils/git_info.g.dart';
const utilGenCodePathBesideCode = 'lib/utils/git_info.g.dart';
const utilExePath = 'lib/utils/git_info.exe';

const binDir = '.dart_tool/pub/bin/gitsumu';
