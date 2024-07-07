const buildConfig =
// language=yaml
    '''
targets:
  \$default:
    builders:
      gitsumu|info:
        generate_for:
          - lib/example.dart
''';
const buildConfigWithExt =
// language=yaml
    '''
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

const code =
// language=dart
    '''
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

// Should only generate on Windows.
@CustomInfo(
  'myCommandResult6',
  platforms: {CustomInfoPlatforms.windows},
)
const name6 = [''];

// Should only generate on Linux.
@CustomInfo(
  'myCommandResult7',
  platforms: {CustomInfoPlatforms.linux},
)
const name7 = [''];

// Should only generate on MacOS.
@CustomInfo(
  'myCommandResult8',
  platforms: {CustomInfoPlatforms.macos},
)
const name8 = [''];
''';

const codeWithExt =
// language=dart
    '''
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

// Should only generate on Windows.
@CustomInfo(
  'myCommandResult6',
  platforms: {CustomInfoPlatforms.windows},
)
const name6 = [''];

// Should only generate on Linux.
@CustomInfo(
  'myCommandResult7',
  platforms: {CustomInfoPlatforms.linux},
)
const name7 = [''];

// Should only generate on MacOS.
@CustomInfo(
  'myCommandResult8',
  platforms: {CustomInfoPlatforms.macos},
)
const name8 = [''];
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
