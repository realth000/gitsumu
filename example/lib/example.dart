import 'package:gitsumu/annotation.dart';

part 'example.g.dart';

// Use this "part" statement if generated file is specified to be in "lib/generated"
// folder in build.yaml.
// part 'generated/example.g.dart';

void printInfo() {
  print('revision: $gitCommitRevisionShort ($gitCommitRevisionLong)');
  print(
      'git commit:    $gitCommitTimeYear-$gitCommitTimeMonth-$gitCommitTimeDay $gitCommitTimeHour:$gitCommitTimeMinute:$gitCommitTimeSecond $gitCommitTimeTimezone}');
  print(
      'built with flutter: $flutterVersion $flutterChannel (framework=$flutterFrameworkRevision engine=$flutterEngineRevision)');
  print('built with dart: $dartVersion');
}

@customInfo
const myCommand = ['echo', '123'];
