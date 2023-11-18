import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/category/components/box_filter.dart';
import 'package:grocery/presentation/screens/category/components/box_sort.dart';
import 'package:grocery/presentation/utils/functions.dart';

class SortFilter extends StatelessWidget {
  const SortFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 6,
            color: const Color(0xFFBABABA).withOpacity(
              0.217,
            ),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            itemSortFilter(
              AppAssets.icFilter,
              'Filter',
              () => openFilterDialog(context),
            ),
            const SizedBox(width: 10),
            const VerticalDivider(
              color: AppColors.gray,
            ),
            const SizedBox(width: 10),
            itemSortFilter(
              AppAssets.icSort,
              'Sort',
              () => openSortDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void openSortDialog(BuildContext context) async {
    showBottomDialog(
      context,
      const BoxSort(),
    );
  }

  void openFilterDialog(BuildContext context) {
    showBottomDialog(
      context,
      const BoxFilter(),
    );
  }

  Widget itemSortFilter(String image, String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            image,
          ),
          const SizedBox(width: 5),
          Text(name, style: AppStyles.regular),
        ],
      ),
    );
  }
}
