import 'dart:async';
import 'dart:io';

Future<(String, String)> _runCommand(String command, List<String> args) async {
  final commandResult = await Process.run(command, args);
  return (commandResult.stdout as String, commandResult.stderr as String);
}

Future<String?> getGitRevisionLong() async {
  final (out, err) = await _runCommand('git', [
    '--no-pager',
    'show',
    '--oneline',
    '--format=%H',
    '-s',
    'HEAD',
  ]);

  if (err.isNotEmpty) {
    print('failed to get git long format revision: $err');
    return null;
  }
  return out.trim();
}

Future<String?> getGitRevisionShort() async {
  final (out, err) = await _runCommand('git', [
    '--no-pager',
    'show',
    '--oneline',
    '--format=%h',
    '-s',
    'HEAD',
  ]);

  if (err.isNotEmpty) {
    print('failed to get git short format revision: $err');
    return null;
  }
  return out.trim();
}

Future<String?> getGitTimeLong() async {
  final (out, err) = await _runCommand('git', [
    '--no-pager',
    'show',
    '--oneline',
    '--format=%cd',
    '--date=format:%F %T %z',
    '-s',
    'HEAD',
  ]);

  if (err.isNotEmpty) {
    print('failed to get git long format commit time: $err');
    return null;
  }
  return out.trim();
}

Future<String?> getGitTimeShort() async {
  final (out, err) = await _runCommand('git', [
    '--no-pager',
    'show',
    '--oneline',
    '--format=%cd',
    '--date=format:%F',
    '-s',
    'HEAD',
  ]);

  if (err.isNotEmpty) {
    print('failed to get git short format commit time: $err');
    return null;
  }
  return out.trim();
}

Future<String?> getFlutterVersion() async {
  final (out, err) = await _runCommand('flutter', ['--version']);
  if (err.isNotEmpty) {
    return null;
  }

  final re = RegExp(r'^Flutter (?<version>[0-9.]+).*');
  final reMatch = re.firstMatch(out.trim());
  final versionString = reMatch?.namedGroup('version');
  return versionString;
}

Future<String?> getDartVersion() async {
  final (out, err) = await _runCommand('dart', ['--version']);
  if (err.isNotEmpty) {
    return null;
  }

  final re = RegExp(r'^Dart SDK version: (?<version>[0-9.]+ \(\w+\)).*');
  final reMatch = re.firstMatch(out.trim());
  final versionString = reMatch?.namedGroup('version');
  return versionString;
}
