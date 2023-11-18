import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/images.dart';

class IconBack extends StatelessWidget {
  const IconBack({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Image.asset(AppAssets.icBack),
    );
  }
}
