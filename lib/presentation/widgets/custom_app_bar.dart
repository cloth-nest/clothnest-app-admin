import 'package:flutter/material.dart';
import 'package:grocery/presentation/widgets/icon_back.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final Widget? title;
  final List<Widget>? actions;
  final bool isCenterTitle;

  const CustomAppBar(
      {super.key, this.title, this.actions, this.isCenterTitle = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.3,
      leading: const IconBack(),
      title: title,
      centerTitle: isCenterTitle,
      actions: actions,
    );
  }
}
