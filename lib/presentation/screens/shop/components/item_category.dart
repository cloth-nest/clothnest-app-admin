import 'package:flutter/material.dart';
import 'package:grocery/data/models/category.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemCategory extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const ItemCategory({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              width: size.width * .2,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(category.bgImgUrl ?? ''),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    color: const Color(0xFFBABABA).withOpacity(0.1325),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            category.name,
            style: AppStyles.regular,
          ),
        ],
      ),
    );
  }
}
