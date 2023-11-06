# Example

Example usage package for gitsumu.

## Usage

1. run `dart run gitsumu` or ```dart run build_runner build` in this example package folder.

2. run `dart run` will generate code like this:
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

**Note that only `dart run gitsumu` supports regeneration**
