import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart'; import 'package:path/path.dart' as path;

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

class AppInfo {
  const AppInfo({
    required this.name,
    required this.description,
    required this.version,
  });

  final String name;
  final String description;
  final String version;
}

Future<(String, String)> runCommand(String command, List<String> args) async {
  final commandResult = await Process.run(command, args, runInShell: true);
  final cleanedOutput = (commandResult.stdout as String).replaceAll('\r', '');
  return (cleanedOutput, commandResult.stderr as String);
}

Future<String?> getGitRevisionLong() async {
  final (out, err) = await runCommand('git', [
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
  final (out, err) = await runCommand('git', [
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
  final (out, err) = await runCommand('git', [
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
  final (out, err) = await runCommand('flutter', ['--version']);
  if (err.isNotEmpty) {
    return null;
  }

  final infoStringList = out.replaceAll('\r', '').split('\n');
  if (infoStringList.length < 4) {
    print('invalid info: $infoStringList');
    return null;
  }

  // Separate regexp into ASCII pieces to avoid encoding error on Windows.
  final re00 = RegExp(r'^Flutter (?<version>[0-9.]+).*');
  final version = re00.firstMatch(infoStringList[0])?.namedGroup('version');
  final re01 = RegExp(r'channel (?<channel>\w+) .*');
  final channel = re01.firstMatch(infoStringList[0])?.namedGroup('channel');

  final re11 = RegExp(r'revision (?<frameworkRevision>\w+) .*');
  final frameworkRevision =
      re11.firstMatch(infoStringList[1])?.namedGroup('frameworkRevision');
  final re12 =
      RegExp(r'(?<frameworkTimestamp>\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d.*)$');
  final frameworkTimestamp =
      re12.firstMatch(infoStringList[1])?.namedGroup('frameworkTimestamp');

  final re2 = RegExp(r'revision (?<revision>\w+)');
  final re2Match = re2.firstMatch(infoStringList[2]);
  final engineRevision = re2Match?.namedGroup('revision');

  final re31 = RegExp(r'Dart (?<dartVersion>[0-9.]+).* ');
  final dartVersion =
      re31.firstMatch(infoStringList[3])?.namedGroup('dartVersion');
  final re32 = RegExp(r'DevTools (?<devToolsVersion>[0-9.]+)');
  final devToolsVersion =
      re32.firstMatch(infoStringList[3])?.namedGroup('devToolsVersion');

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
  final (out, err) = await runCommand('dart', ['--version']);
  if (err.isNotEmpty) {
    return null;
  }

  final re = RegExp(r'^Dart SDK version: (?<version>[0-9.]+ \(\w+\)).*');
  final reMatch = re.firstMatch(out.trim());
  final versionString = reMatch?.namedGroup('version');
  return versionString;
}

Future<AppInfo?> getAppInfo() async {
  final configFile = Directory.current
      .listSync()
      .whereType<File>()
      .firstWhereOrNull((e) => path.basename(e.path) == 'pubspec.yaml');
  if (configFile == null) {
    return null;
  }
  final re0 = RegExp(r'^name: *(?<name>[^ ]*)$');
  final re1 = RegExp(r'^description: *(?<description>.*)$');
  final re2 = RegExp(r'^version: *(?<version>[^ ]*)$');

  final lines = await configFile.readAsLines();

  final name = re0
      .firstMatch(lines.firstWhereOrNull((e) => re0.hasMatch(e)) ?? '')
      ?.namedGroup('name');
  final description = re1
      .firstMatch(lines.firstWhereOrNull((e) => re1.hasMatch(e)) ?? '')
      ?.namedGroup('description');
  final version = re2
      .firstMatch(lines.firstWhereOrNull((e) => re2.hasMatch(e)) ?? '')
      ?.namedGroup('version');
  if (name == null || description == null || version == null) {
    print(
        'incomplete app info: name=$name, description=$description, version=$version');
    return null;
  }
  return AppInfo(
    name: name,
    description: description,
    version: version,
  );
}
