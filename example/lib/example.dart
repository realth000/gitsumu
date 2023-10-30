part 'example.g.dart';

// Use this "part" statement if generated file is specified to be in "lib/generated" folder.
// part 'generated/example.g.dart';

void printInfo() {
  print('revision: $gitCommitRevisionShort ($gitCommitRevisionLong)');
  print('times:    $gitCommitTimeShort ($gitCommitTimeLong)');
  print('built with flutter: $flutterVersion');
  print('built with dart: $dartVersion');
}
