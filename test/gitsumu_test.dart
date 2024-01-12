import 'dart:io';

import 'package:test/test.dart';

import 'constants.dart';
import 'utils.dart';

Future<void> main() async {
  group('dart project', () {
    final repoName = 'basic_dart_project';
    final repo = TestRepo(repoName);

    setUp(() async {
      await repo.createDartProject();
    });

    tearDown(() async {
      await repo.cleanUp();
    });

    test('basic', () async {
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
      final out1 = await Process.run('$repoName/$exePath', ['gitRevisionLong']);
      expect(commitHash, (out1.stdout as String).replaceAll('\r', ''),
          reason: 'expected to have the latest git commit revision hash');

      // Custom info
      final out2 = await Process.run('$repoName/$exePath', ['customInfo']);
      expect((out2.stdout as String).trim().isNotEmpty, true);
      final out3 = await Process.run('$repoName/$exePath', ['customInfo2']);
      expect((out3.stdout as String).replaceAll('\r', ''), equals('\n'));
      final out4 =
          await Process.run('$repoName/$exePath', ['customFromStderr']);
      expect((out4.stdout as String).trim().isNotEmpty, true);

      print('passed');
    });

    test('with build_extensions', () async {
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
      await repo.build(utilCodePath);
      final executableFile = File('$repoName/$utilExePath');
      expect(executableFile.existsSync(), true,
          reason: 'this executable should built successfully');

      final commitHash = await File('$repoName/$gitRef').readAsString();
      final out1 =
          await Process.run('$repoName/$utilExePath', ['gitRevisionLong']);
      expect(commitHash, (out1.stdout as String).replaceAll('\r', ''),
          reason: 'expected to have the latest git commit revision hash');

      // Custom info
      final out2 = await Process.run('$repoName/$utilExePath', ['customInfo']);
      expect((out2.stdout as String).trim().isNotEmpty, true);
      final out3 = await Process.run('$repoName/$utilExePath', ['customInfo2']);
      expect((out3.stdout as String).replaceAll('\r', ''), equals('\n'));
      final out4 =
          await Process.run('$repoName/$utilExePath', ['customFromStderr']);
      expect((out4.stdout as String).trim().isNotEmpty, true);

      print('passed');
    });

    test(
      'with build_runner',
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
        await repo.build(codePath);
        final executableFile = File('$repoName/$exePath');
        expect(executableFile.existsSync(), true,
            reason: 'this executable should built successfully');

        final commitHash = await File('$repoName/$gitRef').readAsString();
        final out1 =
            await Process.run('$repoName/$exePath', ['gitRevisionLong']);
        expect(commitHash, (out1.stdout as String).replaceAll('\r', ''),
            reason: 'expected to have the latest git commit revision hash');

        print('passed');
      },
      timeout: Timeout.factor(2),
    );

    test(
      'with build_runner and build_extensions',
      () async {
        await repo.addBuildRunnerDependency();
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
            reason:
                'the default build_extensions file should not be generated');
        await repo.build(utilCodePath);
        final executableFile = File('$repoName/$utilExePath');
        expect(executableFile.existsSync(), true,
            reason: 'this executable should built successfully');

        final commitHash = await File('$repoName/$gitRef').readAsString();
        final out1 =
            await Process.run('$repoName/$utilExePath', ['gitRevisionLong']);
        expect(commitHash, (out1.stdout as String).replaceAll('\r', ''),
            reason: 'expected to have the latest git commit revision hash');

        print('passed');
      },
      timeout: Timeout.factor(2),
    );
  });
}
