# gitsumu

Dart package provides code about compile environment.

## Introduce

`gitsumu` provides the following info so that apps can use in code.

* [x] Git commit time.
* [x] Git commit revision.
* [x] Flutter version.
* [x] Dart version.

## Features

* Only `dev_dependencies`: No runtime overhead.
* Easier to use than `dart-define`: Only requires `build_runner`, one command at compile time.
* Use info like const variables: All info generated are const variables.

## Usage

* Full example is in the [example](example) folder.

1. Add `gitsumu` and `build_runner` to `dev_dependencies` in `pubspec.yaml`.
   ``` yaml
   dev_dependencies:
     build_runner: # current version or any version
     gitsumu: # current version
   ```
2. Create a source file to let `gitsumu` generate code, such as "lib/example.dart".
   In that source file the only thing required is statement "part 'example.g.dart'".
   Looks like this:
   ``` dart
   // lib/example.dart
   part 'example.g.dart';
   ```
3. Save the following config in `build.yaml` to let `gitsumu` know which file should generate for.
   ```yaml
   targets:
     $default:
       builders:
         gitsumu|info:
           generate_for:
             - lib/example.dart
   ```
4. Then use generated info like this:
   ```dart
   // Some other file that use these info.
   import 'example.dart';
   
   void printInfo() {
     print('revision: $gitCommitRevisionShort ($gitCommitRevisionLong)');
     print(
     'git commit:    $gitCommitTimeYear-$gitCommitTimeMonth-$gitCommitTimeDay $gitCommitTimeHour:$gitCommitTimeMinute:$gitCommitTimeSecond $gitCommitTimeTimezone}');
     print(
     'built with flutter: $flutterVersion $flutterChannel (framework=$flutterFrameworkRevision engine=$flutterEngineRevision)');
     print('built with dart: $dartVersion');
   }
   ```
5. Run `dart run build_runner build` before build to generate "lib/example.g.dart".
