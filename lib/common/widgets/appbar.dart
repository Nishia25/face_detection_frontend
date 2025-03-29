import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  const Appbar({
    super.key, 
    required this.title, 
    this.icon, 
    this.onIconPressed, 
    this.onLeadingPressed, 
    this.showBackButton = false,
    this.reactiveIcon,
  });

  final String title;
  final Icon? icon;
  final Widget? reactiveIcon;
  final VoidCallback? onIconPressed;
  final bool showBackButton;
  final VoidCallback? onLeadingPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(237, 29, 36, 1),
      elevation: 0.0,
      toolbarHeight: 80,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: onLeadingPressed ?? () {
                Navigator.of(context).pop();
              },
            )
          : null,
      actions: [
        if (reactiveIcon != null)
          IconButton(
            icon: reactiveIcon!,
            onPressed: onIconPressed ?? () {},
          )
        else if (icon != null)
          IconButton(
            icon: icon!,
            onPressed: onIconPressed ?? () {},
          ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(237, 29, 36, 1),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
} 