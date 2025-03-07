import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.amberAccent,
      ),
    );
  }
}
