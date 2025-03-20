import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class Bottombar extends StatelessWidget {
  const Bottombar({super.key, this.selectedIndex = 0, this.onTabChange});

  final int selectedIndex;
  final void Function(int index)? onTabChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GNav(
          padding: const EdgeInsets.all(10),
          tabBackgroundColor: Colors.blueAccent,
          activeColor: Colors.white,
          color: Color.fromRGBO(117, 117, 117, 1),
          onTabChange: onTabChange,
          selectedIndex: selectedIndex,
          tabs: [
            GButton(
              gap: 8,
              icon: Icons.home_outlined,
              leading: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Colors.white : Color.fromRGBO(117, 117, 117, 1),
              ),
              text: 'Home',
            ),
            GButton(
              gap: 8,
              icon: Icons.groups_outlined,
              leading: Icon(
                Icons.camera_alt_rounded,
                color: selectedIndex == 1 ? Colors.white : Color.fromRGBO(117, 117, 117, 1),
              ),
              text: 'Screenshots',
            ),
            GButton(
              gap: 8,
              icon: Icons.bookmark_border_outlined,
              leading: Icon(
                Icons.route_outlined,
                color: selectedIndex == 2 ? Colors.white : Color.fromRGBO(117, 117, 117, 1),
              ), // No leading ImageIcon here, default icon used.
              text: 'Route',
            ),
            GButton(
              gap: 8,
              icon: Icons.person_outline_rounded,
              leading: Icon(
                Icons.person,
                color: selectedIndex == 3 ? Colors.white : Color.fromRGBO(117, 117, 117, 1),
              ),
              text: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
