import 'package:flutter/material.dart';
import 'package:grocery/data/models/cart_entity.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/transactions/components/w_icon_edit_cart.dart';
import 'package:intl/intl.dart';

class WItemCart extends StatelessWidget {
  final CartEntity cart;
  final VoidCallback onTapAdd;
  final VoidCallback onTapMinus;

  const WItemCart({
    super.key,
    required this.cart,
    required this.onTapAdd,
    required this.onTapMinus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 10.0,
          right: 20,
        ),
        child: Row(
          children: [
            Image.network(
              cart.image,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: AppColors.box,
                );
              },
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.name,
                    style: AppStyles.medium.copyWith(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    cart.price.toMoney(),
                    style: AppStyles.semibold.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                WIconEditCart(
                  child: const Positioned(
                    bottom: 7,
                    child: Icon(
                      Icons.minimize,
                      size: 17,
                      color: AppColors.primary,
                    ),
                  ),
                  callback: () {
                    onTapAdd.call();
                  },
                ),
                const SizedBox(width: 10),
                Text('${cart.quantity}', style: AppStyles.bold),
                const SizedBox(width: 10),
                WIconEditCart(
                  child: const Icon(
                    Icons.add,
                    size: 17,
                    color: AppColors.primary,
                  ),
                  callback: () {
                    onTapMinus.call();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

extension DoubleX on double {
  String toMoney() {
    final format =
        NumberFormat.simpleCurrency(locale: 'EN-us', decimalDigits: 2);
    String cur = format.format(this).toString();
    return cur;
  }
}
