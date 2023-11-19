import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/category/components/i_category.dart';

class ItemCategory extends StatelessWidget implements ICategory {
  final String title;
  final int size;

  const ItemCategory({super.key, required this.title, required this.size});

  @override
  Widget build(BuildContext context) {
    return render(context);
  }

  @override
  int getSize() {
    return size;
  }

  @override
  Widget render(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: ListTile(
        title: Text(
          title,
          style: AppStyles.medium,
        ),
        trailing: Text(
          size.toString(),
          style: AppStyles.regular,
        ),
        dense: true,
      ),
    );
  }
}
