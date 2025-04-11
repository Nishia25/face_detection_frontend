import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../common/widgets/appbar.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: "About Us",
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
                // Top banner
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/drowsy_banner.png'), // Add your own image in assets
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Drive Aware, Accidents Beware",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Introduction
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "About the Project",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "This project aims to prevent road accidents caused by drowsy driving by monitoring the driver in real-time. Both the car owner and the driver are alerted instantly when signs of drowsiness are detected.",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Features
                        const Text(
                          "Key Features",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        FeatureTile(icon: LucideIcons.video, text: "Live video monitoring"),
                        FeatureTile(icon: LucideIcons.brain, text: "AI-based drowsiness detection"),
                        FeatureTile(icon: LucideIcons.bell, text: "Instant alert via FCM"),
                        FeatureTile(icon: LucideIcons.camera, text: "Screenshot when drownsyness are detected"),
                        FeatureTile(icon: LucideIcons.map_pin, text: "Live location tracking"),
                        FeatureTile(icon: LucideIcons.user_cog, text: "Profile & account management"),
                        FeatureTile(icon: LucideIcons.phone_call, text: "Emergency contacts"),

                        const SizedBox(height: 20),

                        // Vision Statement
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          color: Colors.teal[50],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: const Text(
                              "Our vision is to make driving safer by supporting both drivers and car owners through technology and real-time awareness.",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable widget for feature tiles
class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
