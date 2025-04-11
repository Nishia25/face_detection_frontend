import 'package:flutter/material.dart';
import '../../../common/widgets/appbar.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: "Terms & Conditions",
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Terms and Conditions",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Please read these terms carefully before using the application.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),

                // Each bullet point
                TermsBullet(
                  title: "1. Device Integration",
                  description:
                  "Our drowsiness detection backend can be integrated into an IoT-based device, which must be properly installed inside the vehicle, facing the driver.",
                ),
                TermsBullet(
                  title: "2. Camera Access",
                  description:
                  "Live monitoring and drowsiness alerts will only function when the camera is active and properly positioned to capture the driver’s face.",
                ),
                TermsBullet(
                  title: "3. Monitoring Requirements",
                  description:
                  "For real-time monitoring and notifications, the vehicle owner must have the app installed and be logged in on their device.",
                ),
                TermsBullet(
                  title: "4. Face Visibility",
                  description:
                  "The system requires a clear view of the driver’s face. Obstructions or poor lighting may reduce detection accuracy.",
                ),
                TermsBullet(
                  title: "5. Data Usage",
                  description:
                  "This application may transmit live video, screenshots, and location data. Ensure you have adequate data allowance when using it.",
                ),
                TermsBullet(
                  title: "6. Privacy",
                  description:
                  "We do not share your data with third parties. All collected data is stored securely and accessible only by authenticated users.",
                ),
                TermsBullet(
                  title: "7. Emergency Use",
                  description:
                  "In case of a detected emergency, the owner can call predefined emergency contacts like ambulance or police directly from the app.",
                ),

                const SizedBox(height: 30),
                const Text(
                  "By using this app, you agree to comply with the above terms and ensure proper installation and usage of the system.",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TermsBullet extends StatelessWidget {
  final String title;
  final String description;

  const TermsBullet({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.teal, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(fontSize: 15, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
