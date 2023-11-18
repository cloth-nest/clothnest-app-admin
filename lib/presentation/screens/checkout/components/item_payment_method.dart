import 'package:flutter/material.dart';
import 'package:grocery/data/models/payment.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemPaymentMethod extends StatelessWidget {
  final Payment payment;
  final bool isPicked;

  const ItemPaymentMethod({
    super.key,
    required this.payment,
    required this.isPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 15,
        left: 20,
        right: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 30,
            color: const Color(0xFF8D979E).withOpacity(0.2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 18,
              top: 18,
              left: 20,
            ),
            child: Row(
              children: [
                Image.asset(
                  payment.img,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 20),
                Text(
                  payment.name,
                  style: AppStyles.medium,
                ),
              ],
            ),
          ),
          isPicked
              ? Positioned(
                  right: 10,
                  top: 10,
                  child: Image.asset(
                    AppAssets.icChecked,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
