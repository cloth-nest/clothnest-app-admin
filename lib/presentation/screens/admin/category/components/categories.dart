import 'package:flutter/material.dart';
import 'package:grocery/presentation/screens/admin/category/components/i_category.dart';

class Categories extends StatelessWidget implements ICategory {
  final String title;
  final bool isInitiallyExpanded;
  final Function(int?)? callback;
  final int? id;
  final List<ICategory> categories = [];

  Categories(
    this.title, {
    super.key,
    this.isInitiallyExpanded = false,
    this.callback,
    this.id,
  });

  void addCategory(ICategory category) => categories.add(category);

  @override
  int getSize() {
    return categories.length;
  }

  @override
  Widget render(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.black),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: GestureDetector(
          onTap: () => callback?.call(id),
          child: ExpansionTile(
            leading: const Icon(Icons.category),
            title: Text('$title (${getSize()}) subcategories'),
            initiallyExpanded: isInitiallyExpanded,
            children: categories
                .map((ICategory category) => category.render(context))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => render(context);

  @override
  int getId() {
    return -1;
  }
}
