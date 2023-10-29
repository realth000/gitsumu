import 'dart:io';

Future<(String, String)> _runCommand(String command, List<String> args) async {
  final commandResult = await Process.run(command, args);
  return (commandResult.stdout as String, commandResult.stderr as String);
}

Future<String?> gitRevisionLong() async {
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

Future<String?> gitRevisionShort() async {
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

Future<String?> gitTimeLong() async {
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

Future<String?> gitTimeShort() async {
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

int calculate() {
  return 6 * 7;
}
