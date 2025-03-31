import 'package:flutter/material.dart';
import 'package:vision_intelligence/common/widgets/appbar.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
