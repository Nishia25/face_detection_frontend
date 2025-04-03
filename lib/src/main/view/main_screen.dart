import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/bottombar.dart';
import '../controller/main_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainController mainController = Get.put(MainController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Obx(() {
      return Scaffold(
          bottomNavigationBar: Bottombar(
            selectedIndex: mainController.selectedIndex.value,
            onTabChange: (index) {
              mainController.selectedIndex.value = index;
            },
          ),
          body: mainController
              .bottomBarScreens[mainController.selectedIndex.value]);
    }));
  }
}
