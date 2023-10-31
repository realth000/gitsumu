import 'package:gitsumu/gitsumu.dart' as gitsumu;

void main(List<String> arguments) async {
  final gitInfo = await gitsumu.getGitTime();
  if (gitInfo == null) {
    return;
  }
  print(gitInfo);

  final gitRevisionLong = await gitsumu.getGitRevisionLong();
  if (gitRevisionLong == null) {
    return;
  }
  print(gitRevisionLong);

  final gitRevisionShort = await gitsumu.getGitRevisionShort();
  if (gitRevisionShort == null) {
    return;
  }
  print(gitRevisionShort);

  final flutterInfo = await gitsumu.getFlutterVersion();
  if (flutterInfo != null) {
    return;
  }
  print(flutterInfo);

  final dartInfo = await gitsumu.getDartVersion();
  if (dartInfo == null) {
    return;
  }
  print(dartInfo);
}
