import 'dart:async';
import 'dart:io';

class GitCommitTimeInfo {
  const GitCommitTimeInfo({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.timeZone,
  });

  final String year;
  final String month;
  final String day;
  final String hour;
  final String minute;
  final String second;
  final String timeZone;

  @override
  String toString() {
    return 'GitCommit { year=$year month=$month day=$day hour=$hour minute=$minute second=$second timezone=$timeZone }';
  }
}

class FlutterInfo {
  const FlutterInfo({
    required this.version,
    required this.channel,
    required this.frameworkRevision,
    required this.frameworkTimestamp,
    required this.engineRevision,
    required this.dartVersion,
    required this.devToolsVersion,
  });

  final String version;
  final String channel;
  final String frameworkRevision;
  final String frameworkTimestamp;
  final String engineRevision;
  final String dartVersion;
  final String devToolsVersion;

  @override
  String toString() {
    return 'FlutterInfo { version=$version channel=$channel revision=$frameworkRevision }';
  }
}

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

Future<GitCommitTimeInfo?> getGitTime() async {
  final (out, err) = await _runCommand('git', [
    '--no-pager',
    'show',
    '--oneline',
    '--format=%cd',
    '--date=format:%Y-%m-%d-%H-%M-%S-%z',
    '-s',
    'HEAD',
  ]);

  if (err.isNotEmpty) {
    print('failed to get git commit time: $err');
    return null;
  }

  final list = out.trim().split('-').toList();
  if (list.length != 7) {
    print('incomplete git commit time, get: $list');
    return null;
  }

  return GitCommitTimeInfo(
    year: list[0],
    month: list[1],
    day: list[2],
    hour: list[3],
    minute: list[4],
    second: list[5],
    timeZone: list[6],
  );
}

Future<FlutterInfo?> getFlutterVersion() async {
  final (out, err) = await _runCommand('flutter', ['--version']);
  if (err.isNotEmpty) {
    return null;
  }

  final infoStringList = out.replaceAll('\r', '').split('\n');
  if (infoStringList.length < 4) {
    print('invalid info: $infoStringList');
    return null;
  }

  final re0 =
      RegExp(r'^Flutter (?<version>[0-9.]+).* channel (?<channel>\w+) .*');
  final re0Match = re0.firstMatch(infoStringList[0]);
  final version = re0Match?.namedGroup('version');
  final channel = re0Match?.namedGroup('channel');

  final re1 = RegExp(
      r'Framework.* revision (?<frameworkRevision>\w+) .* (?<frameworkTimestamp>[^ ]+ [^ ]+ [^ ]+)$');
  final re1Match = re1.firstMatch(infoStringList[1]);
  final frameworkRevision = re1Match?.namedGroup('frameworkRevision');
  final frameworkTimestamp = re1Match?.namedGroup('frameworkTimestamp');

  final re2 = RegExp(r'Engine.* revision (?<revision>\w+)');
  final re2Match = re2.firstMatch(infoStringList[2]);
  final engineRevision = re2Match?.namedGroup('revision');

  final re3 = RegExp(
      r'Tools.* Dart (?<dartVersion>[0-9.]+).* DevTools (?<devToolsVersion>[0-9.]+)');
  final re3Match = re3.firstMatch(infoStringList[3]);
  final dartVersion = re3Match?.namedGroup('dartVersion');
  final devToolsVersion = re3Match?.namedGroup('devToolsVersion');

  if (version == null ||
      channel == null ||
      frameworkRevision == null ||
      frameworkTimestamp == null ||
      engineRevision == null ||
      dartVersion == null ||
      devToolsVersion == null) {
    print('invalid flutter info: version=$version, channel=$channel, '
        'frameworkRevision=$frameworkRevision, frameworkTimestamp=$frameworkTimestamp, '
        'engineRevision=$engineRevision, '
        'dartVersion=$dartVersion, devToolsVersion=$devToolsVersion');
    return null;
  }
  return FlutterInfo(
    version: version,
    channel: channel,
    frameworkRevision: frameworkRevision,
    frameworkTimestamp: frameworkTimestamp,
    engineRevision: engineRevision,
    dartVersion: dartVersion,
    devToolsVersion: devToolsVersion,
  );
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
