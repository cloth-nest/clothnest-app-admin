import 'package:flutter/material.dart';
import 'package:grocery/data/models/transaction.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemTag extends StatelessWidget {
  final OrderStatus orderStatus;

  const ItemTag({super.key, required this.orderStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: convertToBackgroundColor(),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        convertToText(),
        style: AppStyles.medium.copyWith(
          color: convertToTextColor(),
        ),
      ),
    );
  }

  String convertToText() {
    switch (orderStatus) {
      case OrderStatus.finished:
        return 'Finished';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'In Progress';
    }
  }

  Color convertToTextColor() {
    switch (orderStatus) {
      case OrderStatus.finished:
        return const Color(0xFF08C25E);
      case OrderStatus.cancelled:
        return const Color(0xFFFF3030);
      default:
        return const Color(0xFF3086FF);
    }
  }

  Color convertToBackgroundColor() {
    switch (orderStatus) {
      case OrderStatus.finished:
        return const Color(0xFFEDFFE5);
      case OrderStatus.cancelled:
        return const Color(0xFFFFE5E5);
      default:
        return const Color(0xFFE5F2FF);
    }
  }
}
