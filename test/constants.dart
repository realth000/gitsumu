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
part "example.g.dart";

void main(List<String> args) {
  print(gitCommitRevisionLong);
}
''';

const codeWithExt = '''
part "../generated/utils/git_info.g.dart";

void main(List<String> args) {
  print(gitCommitRevisionLong);
}
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
