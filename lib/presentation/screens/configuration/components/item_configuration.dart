import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemConfiguration extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const ItemConfiguration({
    super.key,
    required this.icon,
    required this.description,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width / 2,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 30,
            height: 30,
            color: Colors.black,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: AppStyles.semibold),
                Text(description, style: AppStyles.regular),
              ],
            ),
          )
        ],
      ),
    );
  }
}
