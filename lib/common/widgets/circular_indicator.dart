import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  final bool isLoading;

  const CircularIndicator({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
      color: Colors.black.withOpacity(0.3), // Semi-transparent background
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    )
        : SizedBox.shrink(); // Return an empty widget if not loading
  }
}
