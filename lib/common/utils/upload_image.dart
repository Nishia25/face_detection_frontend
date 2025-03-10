import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

class UploadImage {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);
    return await _saveImageLocally(imageFile);
  }

  Future<File> _saveImageLocally(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory(); // Local directory
    final path = "${directory.path}/profile_image.jpg"; // Image ka path set karein
    final File localImage = await imageFile.copy(path); // Image ko local storage me save karein

    var box = await Hive.openBox('userBox');
    String? userId = box.get('user_id'); // Fetch stored userId
    if (userId != null) {
      await _saveImagePathToHive(userId, path); // Save with userId
    } else {
      await _saveImagePathToHive("default", path); // Fallback if no userId
    }

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
