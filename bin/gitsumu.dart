import 'package:gitsumu/gitsumu.dart' as gitsumu;

void main(List<String> arguments) async {
  final gitTimeLong = await gitsumu.getGitTimeLong();
  if (gitTimeLong == null) {
    return;
  }
  print(gitTimeLong);

  final gitTimeShort = await gitsumu.getGitTimeShort();
  if (gitTimeShort == null) {
    return;
  }
  print(gitTimeShort);

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
}
