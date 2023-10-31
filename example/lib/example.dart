part 'example.git.dart';

// Use this "part" statement if generated file is specified to be in "lib/generated" folder.
// part 'generated/example.g.dart';

void printInfo() {
  print('revision: $gitCommitRevisionShort ($gitCommitRevisionLong)');
  print(
      'git commit:    $gitCommitTimeYear-$gitCommitTimeMonth-$gitCommitTimeDay $gitCommitTimeHour:$gitCommitTimeMinute:$gitCommitTimeSecond $gitCommitTimeTimezone}');
  print(
      'built with flutter: $flutterVersion $flutterChannel (framework=$flutterFrameworkRevision engine=$flutterEngineRevision)');
  print('built with dart: $dartVersion');
}
