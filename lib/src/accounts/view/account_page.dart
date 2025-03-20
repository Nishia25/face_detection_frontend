import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/common/config/app_images.dart';
import 'package:vision_intelligence/common/widgets/custom_appbar.dart';

import '../accounts_pages/about_us.dart';
import '../accounts_pages/change_password.dart';
import '../accounts_pages/contact_us.dart';
import '../accounts_pages/delete_account.dart';
import '../accounts_pages/myprofile.dart';
import '../accounts_pages/terms_conditions.dart';
import '../controller/account_controller.dart';
import '../widgets/setting_options.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountController accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            CustomAppbar(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)
                  )
                ),
                child: SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Accounts"),
                  SizedBox(height: 5,),
                  SettingOptions(
                    icon: Icon(
                      Icons.person_outline,
                    ),
                    title: "My Profile",
                    onTap: () {
                      Get.to(() => Myprofile());
                    },
                  ),
                  SettingOptions(
                    icon: ImageIcon(
                      AssetImage(AppImages.password_icon,),
                      color: Colors.black,
                    ),
                    title: "Change Password",
                    onTap: () {
                      Get.to(() => ChangePassword());
                    },
                  ),
                  SettingOptions(
                    icon: ImageIcon(
                      AssetImage(AppImages.delete_icon),
                      color: Colors.black,
                    ),
                    title: "Delete Account",
                    onTap: () {
                      Get.to(() => DeleteAccount());
                    },
                  ),
                  SettingOptions(
                    icon: ImageIcon(
                      AssetImage(AppImages.notification_icon),
                      color: Colors.black,
                    ),
                    title: "Notification",
                    trailing: Obx(() {
                      return Transform.scale(
                        scale: 0.8,
                        child: Switch.adaptive(
                          value: accountController.lights.value,
                          onChanged: (bool value) {
                            accountController.lights.value = value;
                          },
                          activeTrackColor: Color.fromRGBO(237, 29, 36, 1),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 10,),
                  _buildSectionTitle("Help & Support"),
                  SizedBox(height: 15,),
                  SettingOptions(
                    icon: Icon(
                      Icons.person_search_outlined,
                    ),
                    title: "About Us",
                    onTap: () {
                      Get.to(() => AboutUs());
                    },
                  ),
                  SettingOptions(
                    icon: Icon(
                      Icons.file_copy_outlined,
                    ),
                    title: "Terms & Conditions",
                    onTap: () {
                      Get.to(() => TermsConditions());
                    },
                  ),
                  SettingOptions(
                    icon: ImageIcon(
                      AssetImage(AppImages.contact_icon),
                      color: Colors.black,
                      size: 24,
                    ),
                    title: "Contact Us",
                    onTap: () {
                      Get.to(() => ContactUs());
                    },
                  ),
                  SettingOptions(
                      icon: Icon(
                        Icons.logout_outlined,
                        size: 24,
                        color: Colors.black,
                      ),
                      title: "Logout",
                      onTap : () {
                        // signOut();
                      }
                  )
                ],
              ),
            ),
      ),
              ),
            )
          ],
        ),
      )
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    ),
  );
}


