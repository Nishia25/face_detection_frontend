import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vision_intelligence/common/widgets/appbar.dart';
import '../controller/contact_us_controller.dart';
import '../../../common/constants/app_images.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactUsController controller = Get.put(ContactUsController());

    return Scaffold(
      appBar: Appbar(
        title: "Emergency Contact",
        showBackButton: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              children: [
                const Text(
                  'Emergency Contacts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 30),
                _buildContactCard(
                  context,
                  controller,
                  'Driver',
                  AppImages.driver,
                  '100',
                  Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildContactCard(
                  context,
                  controller,
                  'Police',
                  AppImages.police,
                  '100',
                  Colors.red,
                ),
                const SizedBox(height: 20),
                _buildContactCard(
                  context,
                  controller,
                  'Ambulance',
                  AppImages.ambulance,
                  '108',
                  Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    ContactUsController controller,
    String title,
    String imagePath,
    String phoneNumber,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => controller.makePhoneCall(phoneNumber),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Tap to call: $phoneNumber',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.phone,
                color: color,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
