# gitsumu

<p>
  <a href="https://github.com/realth000/gitsumu/actions/workflows/test.yml"><img src="https://github.com/realth000/gitsumu/actions/workflows/test.yml/badge.svg" alt="test_ci"></a>
  <a href="https://pub.dev/packages/gitsumu"><img src="https://img.shields.io/pub/v/gitsumu?logo=dart" alt="pub_version"></a>
  <a href="https://pub.dev/packages/gitsumu"><img src="https://img.shields.io/pub/points/gitsumu?logo=dart" alt="pub_points"></a>
  <a href="https://pub.dev/packages/gitsumu"><img src="https://img.shields.io/pub/likes/gitsumu?logo=dart" alt="pub_likes"></a>
  <a href="https://pub.dev/packages/gitsumu"><img src="https://img.shields.io/pub/dm/gitsumu?logo=dart" alt="pub_popularity"></a>
</p>

Dart package provides code about compile environment (git info, flutter version ...).

## Introduction

`gitsumu` generates the following info as const variables.

* [x] Git commit time.
* [x] Git commit revision.
* [x] Git commit count in repo.
* [x] Git commit count on current branch.
* [x] Flutter version.
* [x] Dart version.
* [x] App info in `pubspec.yaml`.
* [x] Custom command.

```dart
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

```

## Features

* Easier to use than `dart-define`: One command at compile time and no platform specified scripts.
* Use info as const variables: All info generated are const variables.

Of course this package supports both pure dart and flutter.

## Usage

`dart run gitsumu` (recommended) or `dart run build_runner build`

### Basic

Full example can be found in [example](example) folder.

1. Add `gitsumu` to `pubspec.yaml`.

   ``` yaml
   dependencies:
     gitsumu: # current version
   ```

   Add `build_runner` to `pubspec.yaml` as dev dependency only if you want to use with `build_runner`.

   ``` yaml
   dev_dependencies:
     build_runner: # current version
   ```

   **Note that only `dart run gitsumu` support regeneration, you need to delete the existing generated file before
   using with `build_runner`. See [restrictions](#restrictions) for details.**
2. Create a source file as an entry, for example `lib/utils/git_info.dart`.<br>
   In that source file the only line required is `part 'git_info.g.dart'`.<br>
   Looks like this:

   ``` dart
   // lib/utils/git_info.dart
   part 'git_info.g.dart';
   ```

3. Save the following config in `build.yaml` to let `gitsumu` know which file should generate for.

   ```yaml
   targets:
     $default:
       builders:
         gitsumu|info:
           generate_for:
             - lib/utils/git_info.dart
   ```

4. Run `dart run gitsumu` (Recommended) or `dart run build_runner build` before build to
   generate `lib/utils/git_info.g.dart`.

   ```
5. Add 'import lib/utils/git_info.dart' when need the generated code.

### Custom info

gitsumu supports saving commands results as const variables.

In the file to generate, define a variable for each command:

```dart

@CustomInfo('myCommandResult')
const aNotImportantName = ['dart', '--help'];

@CustomInfo('myCommandResult2', ignoreStderr: true)
const alsoNotImportantName = ['git', 'checkout', '123456789'];

@CustomInfo('myCommandFromStderr', useStderr: true)
const alsoNotImportantName2 = ['git', 'abc'];

@CustomInfo(
  'myCommandResult3',
  platforms: {
    CustomInfoPlatforms.linux,
    CustomInfoPlatforms.macos,
  },
)
const alsoNotImportantName3 = ['arch'];

@CustomInfo(
  'myCommandResult4',
  platforms: {
    CustomInfoPlatforms.windows,
  },
  platformDefaultValue: 'unknown',
)
const alsoNotImportantName4 = ['hostname'];
```

Variable name is not important, generated code will use the first argument in annotation `@CustomInfo()` as variable's name.

Generated code:

```dart
// Custom info
const myCommandResult = '''A command-line utility for Dart development.

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
const myCommandResult2 = '''''';
const myCommandFromStderr = '''git: 'abc' is not a git command. See 'git --help'.

The most similar command is
 add''';
const myCommandResult3 = '''x86_64''';
const myCommandResult4 = '''unknown''';
```

Options:

* `ignoreStderr`: Still save contents if the custom command write content to stderr. `bool` type, default is false.
* `useStderr`: Save the content in stderr as result. `bool` type, default is false.
* `platforms`: Specify only run the command on which platform, default run on all platforms.
* `platformDefaultValue`: Set the command result on platforms that not included in `platforms`, default is an empty string.

### Change save path

Works like other packages. Adding the following code to `build.yaml` will generate the file in `lib/generated/` directory:

```yaml
targets:
  $default:
    builders:
      gitsumu|info:
        generate_for:
          # Only generate for lib/utils/git_info.dart => git_info.g.dart
          - lib/utils/git_info.dart
        # Use the following "options" config if you want to generate
        # code into specified folder such as "lib/generated".
        # At the same time, you shall use "part of 'generated/xxx.g.dart';" in your source file
        # instead of current "part of 'xxx.g.dart';".
        # Also, recommend to add "lib/generated/" to .gitignore.
        options:
          build_extensions:
            '^lib/{{}}.dart': 'lib/generated/{{}}.g.dart'
```

## Restrictions

As said above, when using with `build_runner` like `dart run build_runner build`, the generated code will not update
even environment updated (a new git commit, flutter version changed ...). This is because gitsumu only relies on
environment, `build_runner` does not know whether we need a rebuild. **Manually delete the generated code before
run `dart run build_runner build` again.**

Although it's ok to use with `build_runner` in a clean
environment (like CI/CD), using the separate cli `dart run gitsumu` is better in development.

## Debugging

Run `dart run gitsumu -v` to enable verbose log output.
