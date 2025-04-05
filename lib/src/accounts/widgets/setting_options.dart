import 'package:flutter/material.dart';

class SettingOptions extends StatelessWidget {
  const SettingOptions({super.key, required this.icon, required this.title, this.trailing, this.onTap,});

  final Widget icon;
  final String title;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color.fromRGBO(242, 244, 247, 1),
                ),
                child: icon,

              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(26, 32, 44, 1)
                  ),
                ),
              ),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color.fromRGBO(6, 32, 44, 1),
                    size: 16,
                  ),
            ],
          ),
        ),
        Divider(height: 20, thickness: 1),
      ],
    );
  }
}
