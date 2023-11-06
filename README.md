# gitsumu

Dart package provides code about compile environment (git info, flutter version ...).

## Introduce

`gitsumu` provides the following info so that apps can use in code.

* [x] Git commit time.
* [x] Git commit revision.
* [x] Flutter version.
* [x] Dart version.
* [ ] Custom command.

## Features

* Easier to use than `dart-define`: One command at compile time.
* No platform specified scripts needed: Only need to do is running `dart run gitsumu` or `dart run build_runner build`.
* Use info like const variables: All info generated are const variables.
* Support both separate cli and `build_runner`: Recommend to separate cli to generate code.

## Usage

### Basic

* Full example is in the [example](example) folder.

1. Add `gitsumu` and `build_runner` (optional) to `pubspec.yaml`.
   ``` yaml
   dependencies:
     gitsumu: # current version
   dev_dependencies:
     build_runner: # current version or any version
   ```
2. Create a source file to let `gitsumu` generate code, such as "lib/example.dart".
   In that source file the only thing required is statement `part 'example.g.dart'`.
   Looks like this:
   ``` dart
   // lib/example.dart
   part 'example.git.dart';
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
4. Run `dart run gitsumu` (Recommended) or `dart run build_runner build` before build to generate "lib/example.g.dart".
    * Note that only `dart run gitsumu` support regeneration, you need to delete the existing generated file before
      using the later `build_runner` one.
5. Will generate code like this:
   ```dart
    part of 'example.dart';
    
    // Compile environment
    const flutterVersion         = '3.13.9';
    const flutterChannel         = 'stable';
    const flutterFrameworkRevision  = 'd211f42860';
    const flutterFrameworkTimestamp = '2023-10-25 13:42:25 -0700';
    const flutterEngineRevision  = '0545f8705d';
    const flutterDartVersion     = '3.1.5';
    const flutterDevToolsVersion = '2.25.0';
    const dartVersion            = '3.1.5 (stable)';
    
    // Repo info
    const gitCommitTimeYear      = '2023';
    const gitCommitTimeMonth     = '11';
    const gitCommitTimeDay       = '06';
    const gitCommitTimeHour      = '17';
    const gitCommitTimeMinute    = '33';
    const gitCommitTimeSecond    = '50';
    const gitCommitTimeTimezone  = '+0800';
    const gitCommitRevisionLong  = '02d0d5803555eaac40730d0c8a0fe95f6f5f18d1';
    const gitCommitRevisionShort = '02d0d58';
    ```

### Change generate dir

Similar to other packages. Add the following lines to `build.yaml` will change the generated file to `lib/generated`
folder:

```yaml
targets:
  $default:
    builders:
      gitsumu|info:
        generate_for:
          # Only generate for lib/example.dart => example.g.dart
          - lib/example.dart
        # Uncomment the following options config if you want to generate
        # code into specified folder, such as "lib/generated".
        # At the same time, you shall use "part of 'generated/xxx.g.dart' in your source file
        # instead of current "part of 'xxx.g.dart'".
        # Also, it is recommended to put "lib/generated" folder in .gitignore.
        options:
          build_extensions:
            '^lib/{{}}.dart': 'lib/generated/{{}}.gitsumu.dart'
```

### Debugging

Run `dart run gitsumu -v` to enable verbose log print.

