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

* Easier to use than `dart-define`: One command at compile time and no platform specified scripts.
* Use info as const variables: All info generated are const variables.

Of course this package supports both pure dart and flutter.

## Usage

`dart run gitsumu` (recommended) or `dart run build_runner build`

### Basic

* Full example can be found in [example](example) folder.

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
   using with `build_runner`. See [restriction](#restriction)**
2. Create a source file as an entry, for example `lib/utils/git_info.dart`.
   In that source file the only line required is `part 'git_info.gitsumu.dart'`.
   Looks like this:
   ``` dart
   // lib/utils/git_info.dart
   part 'git_info.gitsumu.dart';
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
   generate `lib/utils/git_info.gitsumu.dart`.
5. Will generate code like this:
   ```dart
    part of 'git_info.dart';
    
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

### Change generate directory

Similar to other packages. Add the following lines to `build.yaml` will change the generated file to `lib/generated/`
folder:

```yaml
targets:
  $default:
    builders:
      gitsumu|info:
        generate_for:
          # Only generate for lib/utils/git_info.dart => git_info.gitsumu.dart
          - lib/utils/gitsumu.dart
        # Uncomment the following options config if you want to generate
        # code into specified folder, such as "lib/generated".
        # At the same time, you shall use "part of 'generated/xxx.gitsumu.dart';" in your source file
        # instead of current "part of 'xxx.gitsumu.dart'".
        # Also, recommend to put "lib/generated/" folder in .gitignore.
        options:
          build_extensions:
            '^lib/{{}}.dart': 'lib/generated/{{}}.gitsumu.dart'
```

## Restriction

As said above, when using with `build_runner` like `dart run build_runner build`, the generated code will not update
even environment updated (a new git commit, flutter version changed ...). This is because gitsumu only relies on
environment, `build_runner` can not know whether we need a rebuild. **You need to delete the generated code before
run `dart run build_runner build` again.**

Though it's ok to use with `build_runner` in a clean
environment (like CI/CD), it's highly recommend to use the separate cli `dart run gitsumu` .

## Debugging

Run `dart run gitsumu -v` to enable verbose log output.
