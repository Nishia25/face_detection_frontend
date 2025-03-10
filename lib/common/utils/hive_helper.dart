import 'package:hive/hive.dart';

class HiveHelper {
  static const String boxName = 'profileBox';

  static Future<void> saveProfileImage(String imageUrl) async {
    var box = Hive.box(boxName);
    await box.put('profileImage', imageUrl);
  }

  static String? getProfileImage() {
    var box = Hive.box(boxName);
    return box.get('profileImage');
  }
}
