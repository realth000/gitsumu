part of 'example.dart';

// Compile environment
const flutterVersion         = '3.44.7';
const flutterChannel         = 'stable';
const flutterFrameworkRevision  = '84fc5cbb22';
const flutterFrameworkTimestamp = '2026-07-17 10:20:17 -0700';
const flutterEngineRevision  = '69c8c61792';
const flutterDartVersion     = '3.12.2';
const flutterDevToolsVersion = '2.57.0';

const dartVersion            = '3.12.2 (stable)';

// Repo info
const gitCommitTimeYear      = '2026';
const gitCommitTimeMonth     = '03';
const gitCommitTimeDay       = '05';
const gitCommitTimeHour      = '23';
const gitCommitTimeMinute    = '16';
const gitCommitTimeSecond    = '14';
const gitCommitTimeYMDHMS  = '2026-03-05 23:16:14';
const gitCommitTimeTimezone  = '+0800';
const gitCommitRevisionLong  = 'af5a01f44baf19742a159f65190dbdf7f608f2e5';
const gitCommitRevisionShort = 'af5a01f';
@Deprecated('gitCommitCount was mistakenly implemented to count total commits from all branches in repo, causing a misleading meaning and should not be used anymore.\n'
'Use these alternatives instead:\n'
'1. To get commits count in repo as what it did before, use gitCommitCountRepo\n'
'2. To get commits count on current branch, use gitCommitCountCurrentBranch')
const gitCommitCount         = '106';
const gitCommitCountRepo          = '106';
const gitCommitCountCurrentBranch = '104';

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

Global
  install     Install or upgrade a Dart CLI tool for global use.
  installed   List globally installed Dart CLI tools.
  uninstall   Remove a globally installed Dart CLI tool.

Project
  build       Build a Dart application including code assets.
  compile     Compile Dart to various formats.
  create      Create a new Dart project.
  pub         Work with packages.
  run         Run a Dart program from a file or a local or remote package.
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
	bash''';
// @@end@@ myCommandFromStderr

// @@start@@ myCommandResult4
const myCommandResult4 = r'''hostname''';
// @@end@@ myCommandResult4
