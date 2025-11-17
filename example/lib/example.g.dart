part of 'example.dart';

// Compile environment
const flutterVersion = '3.38.1';
const flutterChannel = 'stable';
const flutterFrameworkRevision = 'b45fa18946';
const flutterFrameworkTimestamp = '2025-11-12 22:09:06 -0600';
const flutterEngineRevision = 'b5990e5ccc';
const flutterDartVersion = '3.10.0';
const flutterDevToolsVersion = '2.51.1';

const dartVersion = '3.10.0 (stable)';

// Repo info
const gitCommitTimeYear = '2025';
const gitCommitTimeMonth = '11';
const gitCommitTimeDay = '17';
const gitCommitTimeHour = '22';
const gitCommitTimeMinute = '58';
const gitCommitTimeSecond = '08';
const gitCommitTimeYMDHMS = '2025-11-17 22:58:08';
const gitCommitTimeTimezone = '+0800';
const gitCommitRevisionLong = '69b738204815c4cfdc3ccff31038aca70eae5d4b';
const gitCommitRevisionShort = '69b7382';
@Deprecated(
    'gitCommitCount was mistakenly implemented to count total commits from all branches in repo, causing a misleading meaning and should not be used anymore.\n'
    'Use these alternatives instead:\n'
    '1. To get commits count in repo as what it did before, use gitCommitCountRepo\n'
    '2. To get commits count on current branch, use gitCommitCountCurrentBranch')
const gitCommitCount = '101';
const gitCommitCountRepo = '101';
const gitCommitCountCurrentBranch = '99';

// App info
const appName = 'example';
const appDescription = 'A sample command-line application.';
const appVersion = '1.0.0';

// @@start@@ myCommandResult
const myCommandResult = r'''A command-line utility for Dart development.

Usage: dart <command|dart-file> [arguments]

Global options:
-v, --verbose               Show additional command output.
    --version               Print the Dart SDK version.
    --enable-analytics      Enable analytics.
    --disable-analytics     Disable analytics.
    --suppress-analytics    Disallow analytics for this `dart *` run without changing the analytics configuration.
-h, --help                  Print this usage information.

Available commands:

Global
  install     Install or upgrade a Dart CLI tool for global use.
  installed   List globally installed Dart CLI tools.
  uninstall   Remove a globally installed Dart CLI tool.

Project
  build       Build a Dart application including code assets.
  compile     Compile Dart to various formats.
  create      Create a new Dart project.
  pub         Work with packages.
  run         Run a Dart program.
  test        Run tests for a project.

Source code
  analyze     Analyze Dart code in a directory.
  doc         Generate API documentation for Dart projects.
  fix         Apply automated fixes to Dart source code.
  format      Idiomatically format Dart source code.

Tools
  devtools    Open DevTools (optionally connecting to an existing application).
  info        Show diagnostic information about the installed tooling.

Run "dart help <command>" for more information about a command.
See https://dart.dev/tools/dart-tool for detailed documentation.''';
// @@end@@ myCommandResult

// @@start@@ myCommandResult2
const myCommandResult2 = r'''''';
// @@end@@ myCommandResult2

// @@start@@ myCommandFromStderr
const myCommandFromStderr = r'''git: 'abc' is not a git command. See 'git --help'.

The most similar command is
	add''';
// @@end@@ myCommandFromStderr

// @@start@@ myCommandResult4
const myCommandResult4 = r'''HOST_NAME_HERE''';
// @@end@@ myCommandResult4
