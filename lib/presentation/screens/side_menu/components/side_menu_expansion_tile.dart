import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/presentation/res/style.dart';

class SideMenuExpansionTile extends StatelessWidget {
  final String icon;
  final String title;
  final List<String> subTitles;
  final Function(String) callback;

  const SideMenuExpansionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitles,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) {
        callback(title);
      },
      title: Row(
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
      initiallyExpanded: false,
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: const EdgeInsets.only(left: 50, bottom: 10),
      children: subTitles
          .map((String title) => GestureDetector(
                onTap: () {
                  callback(title);
                },
                child: Text(
                  title,
                  style: AppStyles.medium,
                ),
              ))
          .toList(),
    );
  }
}
