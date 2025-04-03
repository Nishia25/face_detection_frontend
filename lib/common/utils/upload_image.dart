import 'dart:io';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import '../controller/userdata_controller.dart';

class UploadImage {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);
    return await _saveImageLocally(imageFile);
  }

  Future<File> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/profile_image.jpg";
    final File localImage = await imageFile.copy(path);

    var box = await Hive.openBox('userBox');
    String? userId = box.get('user_id');
    if (userId != null) {
      await _saveImagePathToHive(userId, path);
    } else {
      await _saveImagePathToHive("default", path);
    }

    // 🔹 UserdataController ko update karein (UI refresh hoga)
    final userdataController = Get.find<UserdataController>();
    userdataController.updateProfileImage(path);

    return localImage;
  }

  Future<void> _saveImagePathToHive(String userId, String path) async {
    var box = await Hive.openBox('userBox');
    await box.put('profile_image_$userId', path);
  }

  String? getSavedImagePath() {
    var box = Hive.box('userBox');
    return box.get('profile_image');
  }

  String? getSavedProfileImage(String userId) {
    var box = Hive.box('userBox');
    return box.get('profile_image_$userId'); // Fetch image path
  }
}
