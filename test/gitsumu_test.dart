import 'dart:io';

import 'package:test/test.dart';

import 'constants.dart';
import 'utils.dart';

Future<void> main() async {
  final repoName = 'basic_dart_project';
  final repo = TestRepo(repoName);
  await repo.createDartProject();

  test('basic dart project', () async {
    final yamlContents = buildConfig;
    await repo.writeBuildYaml(yamlContents);

    final dartContents = code;
    await repo.writeDartFile(codePath, dartContents);

    await repo.commitGit();
    await repo.generateCode();

    print('testing results');

    final generatedFile = File('$repoName/$genCodePath');
    expect(generatedFile.existsSync(), true,
        reason: 'this file should be generated');
    await repo.build(codePath);
    final executableFile = File('$repoName/$exePath');
    expect(executableFile.existsSync(), true,
        reason: 'this executable should built successfully');

    final commitHash = await File('$repoName/$gitRef').readAsString();
    final out1 = await Process.run('$repoName/$exePath', []);
    expect(commitHash, out1.stdout as String,
        reason: 'expected to have the latest git commit revision hash');

    print('passed');
  });

  test('basic dart project with build_extensions', () async {
    final yamlContents = buildConfigWithExt;
    await repo.writeBuildYaml(yamlContents);
    final dartContents = codeWithExt;
    await repo.writeDartFile(utilCodePath, dartContents);
    await repo.commitGit();
    await repo.generateCode();

    print('testing results');

    final generatedFile = File('$repoName/$utilGenCodePath');
    expect(generatedFile.existsSync(), true,
        reason: 'this file should be generated');
    final notGeneratedFile = File('$repoName/$utilGenCodePathBesideCode');
    expect(notGeneratedFile.existsSync(), false,
        reason: 'the default build_extensions file should not be generated');
    await repo.build('lib/utils/git_info.dart');
    final executableFile = File('$repoName/$utilExePath');
    expect(executableFile.existsSync(), true,
        reason: 'this executable should built successfully');

    final commitHash = await File('$repoName/$gitRef').readAsString();
    final out1 = await Process.run('$repoName/$utilExePath', []);
    expect(commitHash, out1.stdout as String,
        reason: 'expected to have the latest git commit revision hash');

    print('passed');
  });

  test(
    'basic dart projcet with build_runner',
    () async {
      await repo.cleanCache();
      await repo.addBuildRunnerDependency();

      final yamlContents = buildConfig;
      await repo.writeBuildYaml(yamlContents);

      final dartContents = code;
      await repo.writeDartFile(codePath, dartContents);

      await repo.commitGit();
      await repo.generateCode(useBuildRunner: true);

      print('testing results');

      final notExistBinDir = Directory('$repoName/$binDir');
      expect(notExistBinDir.existsSync(), false,
          reason:
              'gitsumu bin dir should not exist, did you cleaned it before test?');
      final generatedFile = File('$repoName/$genCodePath');
      expect(generatedFile.existsSync(), true,
          reason: 'this file should be generated');
      await repo.build('lib/example.dart');
      final executableFile = File('$repoName/$exePath');
      expect(executableFile.existsSync(), true,
          reason: 'this executable should built successfully');

      final commitHash = await File('$repoName/$gitRef').readAsString();
      final out1 = await Process.run('$repoName/$exePath', []);
      expect(commitHash, out1.stdout as String,
          reason: 'expected to have the latest git commit revision hash');

      print('passed');
    },
    timeout: Timeout.factor(2),
  );

  test(
    'basic dart project with build_runner and build_extensions',
    () async {
      await repo.cleanCache();
      final yamlContents = buildConfigWithExt;
      await repo.writeBuildYaml(yamlContents);
      final dartContents = codeWithExt;
      await repo.writeDartFile(utilCodePath, dartContents);
      await repo.commitGit();
      await repo.generateCode(useBuildRunner: true);

      print('testing results');

      final notExistBinDir = Directory('$repoName/$binDir');
      expect(notExistBinDir.existsSync(), false,
          reason:
              'gitsumu bin dir should not exist, did you cleaned it before test?');
      final generatedFile = File('$repoName/$utilGenCodePath');
      expect(generatedFile.existsSync(), true,
          reason: 'this file should be generated');
      final notGeneratedFile = File('$repoName/$utilGenCodePathBesideCode');
      expect(notGeneratedFile.existsSync(), false,
          reason: 'the default build_extensions file should not be generated');
      await repo.build('lib/utils/git_info.dart');
      final executableFile = File('$repoName/$utilExePath');
      expect(executableFile.existsSync(), true,
          reason: 'this executable should built successfully');

      final commitHash = await File('$repoName/$gitRef').readAsString();
      final out1 = await Process.run('$repoName/$utilExePath', []);
      expect(commitHash, out1.stdout as String,
          reason: 'expected to have the latest git commit revision hash');

      print('passed');
    },
    timeout: Timeout.factor(2),
  );

  // Only convinient for local tests, delete test project after all tests passed.
  // It's ok to skip this step when debugging failed tests.
  test('cleaning up', () async {
    await repo.cleanUp();
  }, skip: false);
}
