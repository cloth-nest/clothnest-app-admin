import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/presentation/res/style.dart';

class SideMenuTile extends StatelessWidget {
  final String icon;
  final String title;

  const SideMenuTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: AppStyles.medium,
          ),
        ],
      ),
    );
  }
}
