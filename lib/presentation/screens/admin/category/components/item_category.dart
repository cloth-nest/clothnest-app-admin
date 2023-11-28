import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/category/components/i_category.dart';

class ItemCategory extends StatelessWidget implements ICategory {
  final String title;
  final int? size;
  final int? id;
  final Widget? leading;

  const ItemCategory({
    super.key,
    required this.title,
    required this.size,
    this.id,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return render(context);
  }

  @override
  int getSize() {
    return size ?? 0;
  }

  @override
  Widget render(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: AppStyles.medium,
        ),
        trailing: Text(
          size == 0 ? '' : size.toString(),
          style: AppStyles.regular,
        ),
        dense: true,
      ),
    );
  }

  @override
  int getId() {
    return id ?? -1;
  }
}
