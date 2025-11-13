part of 'example.dart';

// Compile environment
const flutterVersion         = '3.38.0';
const flutterChannel         = 'stable';
const flutterFrameworkRevision  = 'a0e9b9dbf7';
const flutterFrameworkTimestamp = '2025-11-11 15:00:09 -0600';
const flutterEngineRevision  = 'cb467e31a5';
const flutterDartVersion     = '3.10.0';
const flutterDevToolsVersion = '2.51.1';

const dartVersion            = '3.10.0-290.4.beta (beta)';

// Repo info
const gitCommitTimeYear      = '2025';
const gitCommitTimeMonth     = '02';
const gitCommitTimeDay       = '20';
const gitCommitTimeHour      = '21';
const gitCommitTimeMinute    = '47';
const gitCommitTimeSecond    = '26';
const gitCommitTimeYMDHMS  = '2025-02-20 21:47:26';
const gitCommitTimeTimezone  = '+0800';
const gitCommitRevisionLong  = '1085135baea7e72df5ffbd6bf435a087b870e28a';
const gitCommitRevisionShort = '1085135';
@Deprecated('gitCommitCount was mistakenly implemented to count total commits from all branches in repo, causing a misleading meaning and should not be used anymore.\n'
'Use these alternatives instead:\n'
'1. To get commits count in repo as what it did before, use gitCommitCountRepo\n'
'2. To get commits count on current branch, use gitCommitCountCurrentBranch')
const gitCommitCount         = '93';
const gitCommitCountRepo          = '93';
const gitCommitCountCurrentBranch = '91';

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
const myCommandResult4 = r'''DESKTOP-TS6OVCN''';
// @@end@@ myCommandResult4