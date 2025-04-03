import 'dart:io';

import 'package:hive/hive.dart';

class HiveHelper {
  static const String boxName = 'profileBox';

  static Future<void> saveProfileImage(String imageUrl) async {
    var box = Hive.box(boxName);
    await box.put('profileImage', imageUrl);
  }

  String? getSavedProfileImage(String userId) {
    final box = Hive.box('userBox');
    String? path = box.get('profile_image_$userId');
    if (path != null && File(path).existsSync()) {
      return path;
    }
    return null;
  }

}
