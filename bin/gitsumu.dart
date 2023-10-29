import 'package:gitsumu/gitsumu.dart' as gitsumu;

void main(List<String> arguments) async {
  final gitTimeLong = await gitsumu.gitTimeLong();
  if (gitTimeLong == null) {
    return;
  }
  print(gitTimeLong);

  final gitTimeShort = await gitsumu.gitTimeShort();
  if (gitTimeShort == null) {
    return;
  }
  print(gitTimeShort);

  final gitRevisionLong = await gitsumu.gitRevisionLong();
  if (gitRevisionLong == null) {
    return;
  }
  print(gitRevisionLong);

  final gitRevisionShort = await gitsumu.gitRevisionShort();
  if (gitRevisionShort == null) {
    return;
  }
  print(gitRevisionShort);
}
