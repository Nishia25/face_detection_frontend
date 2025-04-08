
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/common/widgets/custom_appbar.dart';
import 'package:vision_intelligence/src/home/controller/home_controller.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final HomeController homeController = Get.find();
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final String streamUrl = 'http://192.168.1.97:5000/video_feed';
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Obx(() {
                final count = homeController.notificationCount.value;
                return Stack(
                  children: [
                    CustomAppbar(
                      icon: Icons.notifications,
                      onPressed: () {
                        print("Settings button pressed");
                        homeController.resetNotificationCount();
                        Get.snackbar(
                            "Notification clean",
                             "All old notification are clean successfully ",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                          margin: EdgeInsets.all(12),
                          duration: Duration(seconds: 3),
                          icon: Icon(Icons.delete_sweep, color: Colors.white),
                        );
                      },
                    ),
                    if (count > 0)
                      Positioned(
                        right: 15,
                        top: 22,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                  ],
                );
              }),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFB0C4DE), // Light Steel Blue
                        Color(0xFFAEC6CF), // Powder Blue
                        Color(0xFF778899), // Light Slate Gray
                        Color(0xFFDCDCDC), // Gainsboro
                        Color(0xFFF0FFFF), // Azure Mist
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30, top: 10, bottom: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20), // Space below AppBar
                          const Text(
                            "Driver",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20), // Space below "Driver" text
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Mjpeg(
                                stream: streamUrl,
                                isLive: true,
                                fit: BoxFit.cover,
                                error: (context, error, stack) => const Center(
                                  child: Text(
                                    "⚠️ Could not load live stream",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Obx(() {
                            final title = homeController.latestNotificationTitle.value;
                            if (title.isEmpty) return SizedBox.shrink();
                            return Center(
                               child: Text(
                                 title,
                                 style: TextStyle(color: Colors.red, fontSize: 40, fontWeight: FontWeight.w500),
                               ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
