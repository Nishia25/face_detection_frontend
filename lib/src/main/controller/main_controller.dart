import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/src/home/view/home_dashboard.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List<Widget> bottomBarScreens = [
    HomeDashboard(),
    // CommunityPage(),
    // MylistScreen(),
    // AccountSetting()
  ];


  @override
  void onInit() {
    super.onInit();

    print("OnInit Called");
  }

  @override
  void onClose() {
    print("onClose Called");
  }
}
