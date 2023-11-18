import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/dimensions.dart';
import 'package:grocery/presentation/res/style.dart';

class CustomButton extends StatelessWidget {
  final String content;
  final VoidCallback onTap;
  final Color? color;
  final double? borderRadius;
  final double? width;
  final Color? textColor;
  final double? margin;
  final Widget? icon;

  const CustomButton({
    super.key,
    this.color,
    required this.content,
    required this.onTap,
    this.borderRadius,
    this.width,
    this.textColor,
    this.margin,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: margin ?? 20),
        child: Container(
          width: width ?? double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: color ?? AppColors.primary,
            borderRadius: BorderRadius.circular(borderRadius ?? kTopPadding),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 10),
              ],
              Text(
                content,
                textAlign: TextAlign.center,
                style: AppStyles.semibold.copyWith(
                  color: textColor ?? Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
