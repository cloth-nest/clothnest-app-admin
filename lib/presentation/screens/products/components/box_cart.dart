import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/images.dart';

class BoxCart extends StatelessWidget {
  const BoxCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.38),
        border: Border.all(
          color: const Color(0xFF000000).withOpacity(0.12),
        ),
      ),
      child: Image.asset(
        AppAssets.icCart,
      ),
    );
  }
}
