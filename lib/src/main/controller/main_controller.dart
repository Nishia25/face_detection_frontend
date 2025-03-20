import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/src/accounts/view/account_page.dart';
import 'package:vision_intelligence/src/home/view/home_dashboard.dart';
import 'package:vision_intelligence/src/route/view/route_page.dart';
import 'package:vision_intelligence/src/screenshots/view/screenshot_page.dart';

class MainController extends GetxController {
  RxInt selectedIndex = 0.obs;

  List<Widget> bottomBarScreens = [
    HomeDashboard(),
    ScreenshotPage(),
    RoutePage(),
    AccountPage()
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
