import 'dart:io';

import 'package:test/test.dart';

import 'utils.dart';

Future<void> main() async {
  final repoName = 'basic_dart_project';
  final repo = TestRepo(repoName);

  test('basic dart project', () async {
    await repo.createDartProject();

    final yamlContents = ''' 
targets:
  \$default:
    builders:
      gitsumu|info:
        generate_for:
          - lib/example.dart
''';
    await repo.writeBuildYaml(yamlContents);

    final dartContents = '''
part "example.gitsumu.dart";

void main(List<String> args) {
  print(gitCommitRevisionLong);
}
''';
    await repo.writeDartFile('lib/example.dart', dartContents);

    await repo.commitGit();
    await repo.generateCode();
    final generatedFile = File('$repoName/lib/example.gitsumu.dart');
    expect(generatedFile.existsSync(), true);
    final notGeneratedFile = File('$repoName/lib/example.g.dart');
    expect(notGeneratedFile.existsSync(), false);
    await repo.build('lib/example.dart');
    final executableFile = File('$repoName/lib/example.exe');
    expect(executableFile.existsSync(), true);

    final commitHash = await File('$repoName/.git/refs/heads/master').readAsString();
    final out1 = await Process.run('$repoName/lib/example.exe', []);
    expect(commitHash, out1.stdout as String);
  });

  test('basic dart project with build_extensions', () async {
      final yamlContents = '''
targets:
  \$default:
    builders:
      gitsumu|info:
        generate_for:
          - lib/utils/git_info.dart
        options:
          build_extensions:
            '^lib/{{}}.dart': 'lib/generated/{{}}.gitsumu.dart'
''';
    await repo.writeBuildYaml(yamlContents);

    final dartContents = '''
part "../generated/utils/git_info.gitsumu.dart";

void main(List<String> args) {
  print(gitCommitRevisionLong);
}
''';
    await repo.writeDartFile('lib/utils/git_info.dart', dartContents);
    await repo.commitGit();
    await repo.generateCode();

    final generatedFile = File('$repoName/lib/generated/utils/git_info.gitsumu.dart');
    expect(generatedFile.existsSync(), true);
    final notGeneratedFile = File('$repoName/lib/utils/git_info.gitsumu.dart');
    expect(notGeneratedFile.existsSync(), false);
    await repo.build('lib/utils/git_info.dart');
    final executableFile = File('$repoName/lib/utils/git_info.exe');
    expect(executableFile.existsSync(), true);

    final commitHash = await File('$repoName/.git/refs/heads/master').readAsString();
    final out1 = await Process.run('$repoName/lib/utils/git_info.exe', []);
    expect(commitHash, out1.stdout as String);
    await repo.cleanUp();
  });
}
