import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/colors.dart';

class WIconEditCart extends StatelessWidget {
  final VoidCallback callback;
  final Widget child;

  const WIconEditCart({
    super.key,
    required this.callback,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
