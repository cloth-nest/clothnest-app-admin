import 'package:flutter/material.dart';
import 'package:grocery/data/models/coupon.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/widgets/box.dart';

class ItemCoupon extends StatelessWidget {
  final Coupon coupon;
  final Function(Coupon) callback;

  const ItemCoupon({
    super.key,
    required this.coupon,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        callback(coupon);
      },
      child: Box(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.network(
                coupon.thumbnail!,
                fit: BoxFit.cover,
                height: 100,
                width: size.width * 0.3,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coupon.couponType, style: AppStyles.medium),
                  Text(
                    coupon.description,
                    style: AppStyles.regular.copyWith(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        'Expired Date: ',
                        style: AppStyles.regular.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      Text(coupon.endDate, style: AppStyles.medium),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Quantity: ',
                        style: AppStyles.regular.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      Text(coupon.quantity.toString(), style: AppStyles.medium),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
