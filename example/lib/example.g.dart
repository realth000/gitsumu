part of 'example.dart';

// Compile environment
const flutterVersion         = '3.27.0';
const flutterChannel         = 'stable';
const flutterFrameworkRevision  = '8495dee1fd';
const flutterFrameworkTimestamp = '2024-12-10 14:23:39 -0800';
const flutterEngineRevision  = '83bacfc525';
const flutterDartVersion     = '3.6.0';
const flutterDevToolsVersion = '2.40.2';

const dartVersion            = '3.6.0 (stable)';

// Repo info
const gitCommitTimeYear      = '2024';
const gitCommitTimeMonth     = '12';
const gitCommitTimeDay       = '03';
const gitCommitTimeHour      = '23';
const gitCommitTimeMinute    = '35';
const gitCommitTimeSecond    = '10';
const gitCommitTimeYMDHMS  = '2024-12-03 23:35:10';
const gitCommitTimeTimezone  = '+0800';
const gitCommitRevisionLong  = 'b3a602b8fdf1067c3b8663c2d1ded45d0204f9b3';
const gitCommitRevisionShort = 'b3a602b';
@Deprecated('gitCommitCount was mistakenly implemented to count total commits from all branches in repo, causing a misleading meaning and should not be used anymore.\n'
'Use these alternatives instead:\n'
'1. To get commits count in repo as what it did before, use gitCommitCountRepo\n'
'2. To get commits count on current branch, use gitCommitCountCurrentBranch')
const gitCommitCount         = '85';
const gitCommitCountRepo           = '85';
const gitCommitCountCurrentBranch = '83';

// App info
const appName        = 'example';
const appDescription = 'A sample command-line application.';
const appVersion     = '1.0.0';

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
  analyze    Analyze Dart code in a directory.
  compile    Compile Dart to various formats.
  create     Create a new Dart project.
  devtools   Open DevTools (optionally connecting to an existing application).
  doc        Generate API documentation for Dart projects.
  fix        Apply automated fixes to Dart source code.
  format     Idiomatically format Dart source code.
  info       Show diagnostic information about the installed tooling.
  pub        Work with packages.
  run        Run a Dart program.
  test       Run tests for a project.

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
const myCommandResult4 = r'''DESKTOP-TS6OVCN''';
// @@end@@ myCommandResult4