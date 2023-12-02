import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemProfile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback callback;

  const ItemProfile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.semibold.copyWith(fontSize: 16)),
              Text(subtitle, style: AppStyles.regular),
            ],
          ),
          const Spacer(),
          Image.asset(AppAssets.icArrowRight),
        ],
      ),
    );
  }
}
