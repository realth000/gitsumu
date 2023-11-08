import 'dart:io';

import 'package:test/test.dart';

import 'utils.dart';

Future<void> main() async {
  final repoName = 'basic_dart_project';
  final repo = TestRepo(repoName);
  await repo.createDartProject();

  test('basic dart project', () async {
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
part "example.g.dart";

void main(List<String> args) {
  print(gitCommitRevisionLong);
}
''';
    await repo.writeDartFile('lib/example.dart', dartContents);

    await repo.commitGit();
    await repo.generateCode();
    final generatedFile = File('$repoName/lib/example.g.dart');
    expect(generatedFile.existsSync(), true, reason: 'this file should be generated');
    await repo.build('lib/example.dart');
    final executableFile = File('$repoName/lib/example.exe');
    expect(executableFile.existsSync(), true, reason: 'this executable should built successfully');

    final commitHash =
        await File('$repoName/.git/refs/heads/master').readAsString();
    final out1 = await Process.run('$repoName/lib/example.exe', []);
    expect(commitHash, out1.stdout as String, reason: 'expected to have the latest git commit revision hash');
  });

  test('basic dart project with build_extensions', () async {
    final yamlContents = '''
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
    await repo.writeBuildYaml(yamlContents);

    final dartContents = '''
part "../generated/utils/git_info.g.dart";

void main(List<String> args) {
  print(gitCommitRevisionLong);
}
''';
    await repo.writeDartFile('lib/utils/git_info.dart', dartContents);
    await repo.commitGit();
    await repo.generateCode();

    final generatedFile =
        File('$repoName/lib/generated/utils/git_info.g.dart');
    expect(generatedFile.existsSync(), true, reason: 'this file should be generated');
    final notGeneratedFile = File('$repoName/lib/utils/git_info.g.dart');
    expect(notGeneratedFile.existsSync(), false, reason: 'the default build_extensions file should not be generated');
    await repo.build('lib/utils/git_info.dart');
    final executableFile = File('$repoName/lib/utils/git_info.exe');
    expect(executableFile.existsSync(), true, reason: 'this executable should built successfully');

    final commitHash =
        await File('$repoName/.git/refs/heads/master').readAsString();
    final out1 = await Process.run('$repoName/lib/utils/git_info.exe', []);
    expect(commitHash, out1.stdout as String, reason: 'expected to have the latest git commit revision hash');
  });

  test('cleaning up', () async {
    await repo.cleanUp();
  }, skip: false);
}
