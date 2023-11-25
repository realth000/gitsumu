import 'dart:async';
import 'dart:io';

class TestRepo {
  TestRepo(this.name, {this.verbose = false});

  String name;

  bool verbose;

  bool isFlutterProject = false;

  Future<void> createDartProject() async {
    final rootDir = Directory(name);
    if (rootDir.existsSync()) {
      _cleanUp(name);
    }
    print('creating dart project');
    await _runCommandInDir(
      'dart',
      ['create', '-t', 'console', name],
    );
    print('adding gitsumu dependency');
    await _runCommandInDir(
      'dart',
      ['pub', 'add', 'gitsumu:{"path":"../"}'],
      path: name,
    );
    print('init git repo');
    await _initGit(name);
  }

  Future<void> createFlutterProject() async {
    if (Directory(name).existsSync()) {
      _cleanUp(name);
    }
    print('creating flutter project');
    await _runCommandInDir(
      'flutter',
      ['create', name],
    );
    print('adding gitsumu dependency');
    await _runCommandInDir(
      'flutter',
      ['pub', 'add', 'gitsumu:{"path":"../../"}'],
      path: name,
    );
    print('init git repo');
    await _initGit(name);
    isFlutterProject = true;
  }

  Future<void> addBuildRunnerDependency() async {
    print('adding build_runner dependency');
    await _runCommandInDir(
      isFlutterProject ? 'flutter' : 'dart',
      ['pub', 'add', 'build_runner', '-d'],
      path: name,
    );
  }

  Future<void> writeBuildYaml(String contents) async {
    print('writing build.yaml');
    final buildYamlFile = File('$name/build.yaml');
    await buildYamlFile.writeAsString(contents);
  }

  Future<void> writeDartFile(String path, String contents) async {
    print('writing dart file: $path');
    final dartFile = File('$name/$path');
    if (!dartFile.parent.existsSync()) {
      await dartFile.parent.create(recursive: true);
    }
    await dartFile.writeAsString(contents);
  }

  Future<void> commitGit() async {
    await _runCommandInDir(
      'git',
      ['add', '.'],
      path: name,
      supressErr: true,
    );

    await _runCommandInDir(
      'git',
      ['commit', '-m', 'commit'],
      path: name,
    );
  }

  Future<void> generateCode({bool useBuildRunner = false}) async {
    print('generating code');
    if (useBuildRunner) {
      await _runCommandInDir(
        'dart',
        ['run', 'build_runner', 'build'],
        path: name,
      );
    } else {
      await _runCommandInDir(
        'dart',
        ['run', 'gitsumu'],
        path: name,
      );
    }
  }

  Future<void> build(String entryFile) async {
    await _runCommandInDir(
      'dart',
      ['compile', 'exe', entryFile],
      path: name,
    );
  }

  /// Delete current project directory.
  Future<void> cleanUp() async {
    await _cleanUp(name);
  }

  /// Delete .dart_tool, generated code and built executable in current project.
  Future<void> cleanCache() async {
    final dartToolsDir = Directory('$name/.dart_tool');
    if (dartToolsDir.existsSync()) {
      await dartToolsDir.delete(recursive: true);
    }

    Directory(name)
        .list(recursive: true)
        .where((e) =>
            e.statSync().type == FileSystemEntityType.file &&
            (e.path.endsWith('.g.dart') || e.path.endsWith('.exe')))
        .forEach((e) => e.deleteSync());
  }

  Future<void> _initGit(String name) async {
    final rootDir = Directory(name);
    await rootDir.create();
    await _runCommandInDir(
      'git',
      ['init'],
      path: name,
      supressErr: true,
    );

    // Disable gpg signing for test.
    await _runCommandInDir(
      'git',
      ['config', 'commit.gpgsign', 'false'],
      path: name,
    );
  }

  Future<void> _cleanUp(String path) async {
    print('cleaning up $path');
    final rootDir = Directory(path);
    await rootDir.delete(recursive: true);
  }

  Future<void> _runCommandInDir(
    String command,
    List<String> args, {
    String? path,
    bool supressErr = false,
  }) async {
    final result = await Process.run(command, args, workingDirectory: path);

    final err = result.stderr as String;

    if (!supressErr && err.isNotEmpty) {
      throw Exception('failed to run command $command $args: $err');
    }

    final out = result.stdout as String;

    if (verbose) {
      print(out);
    }
    return;
  }
}
