import 'package:get/get.dart';

class HomeController extends GetxController{
  RxInt notificationCount = 0.obs;
  RxString latestNotificationTitle = ''.obs;

  void incrementNotificationCount() {
    notificationCount.value++;
  }

  void resetNotificationCount() {
    notificationCount.value = 0;
  }

  void showNotificationTitle(String title) {
    latestNotificationTitle.value = title;

    Future.delayed(Duration(seconds: 5), () {
      latestNotificationTitle.value = ''; // Clear after 3 secs
    });
  }
}