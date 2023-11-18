import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemTagOrder extends StatelessWidget {
  final String status;
  const ItemTagOrder({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: convertToBackgroundColor(status),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        status,
        style: AppStyles.medium.copyWith(
          color: convertToTextColor(status),
        ),
      ),
    );
  }

  Color convertToTextColor(String orderStatus) {
    switch (orderStatus) {
      case 'Finished':
        return const Color(0xFF08C25E);
      case 'Cancelled':
        return const Color(0xFFFF3030);
      default:
        return const Color(0xFF3086FF);
    }
  }

  Color convertToBackgroundColor(String orderStatus) {
    switch (orderStatus) {
      case 'Finished':
        return const Color(0xFFEDFFE5);
      case 'Cancelled':
        return const Color(0xFFFFE5E5);
      default:
        return const Color(0xFFE5F2FF);
    }
  }
}
