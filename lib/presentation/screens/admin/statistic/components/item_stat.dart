import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemStat extends StatelessWidget {
  final String title;
  final int number;
  final Color color;
  const ItemStat({
    super.key,
    required this.title,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppStyles.medium.copyWith(
            color: color,
          ),
        ),
        const Spacer(),
        Text(number.toString(), style: AppStyles.medium),
      ],
    );
  }
}
