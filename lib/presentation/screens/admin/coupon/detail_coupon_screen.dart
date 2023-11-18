import 'package:flutter/material.dart';
import 'package:grocery/data/models/coupon.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/widgets/box.dart';
import 'package:grocery/presentation/widgets/icon_back.dart';

class DetailCouponScreen extends StatelessWidget {
  final Coupon coupon;

  const DetailCouponScreen({
    super.key,
    required this.coupon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const IconBack(),
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
        title: Text(
          'Detail Coupon',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
        actions: [
          // GestureDetector(
          //   onTap: () {
          //     // Navigator.of(context).push(
          //     //   MaterialPageRoute(
          //     //     builder: (_) => const AddCouponScreen(),
          //     //   ),
          //     // );
          //   },
          //   child: const Icon(
          //     Icons.add,
          //     color: AppColors.primary,
          //     size: 28,
          //   ),
          // ),
          const SizedBox(width: 5),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.network(
                    coupon.thumbnail!,
                    height: 140,
                    fit: BoxFit.cover,
                    width: size.width * 0.3,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Type: ',
                          style: AppStyles.regular.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text(coupon.couponType, style: AppStyles.medium),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Discount: ',
                          style: AppStyles.regular.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text(coupon.discount.toString(),
                            style: AppStyles.medium),
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
                        Text(coupon.quantity.toString(),
                            style: AppStyles.medium),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Start Date: ',
                          style: AppStyles.regular.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text(coupon.fromDate, style: AppStyles.medium),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'End Date: ',
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
                          'Price Point Accept: ',
                          style: AppStyles.regular.copyWith(
                            fontSize: 14,
                          ),
                        ),
                        Text('${coupon.pricePointAccept.toString()}\$',
                            style: AppStyles.medium),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(coupon.description, style: AppStyles.medium),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Wrap(
              runSpacing: 10,
              children: coupon.couponItemList!
                  .map(
                    (e) => Box(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Id: ',
                                    style: AppStyles.regular.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(e.id.toString(),
                                      style: AppStyles.medium),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Code: ',
                                    style: AppStyles.regular.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(e.code, style: AppStyles.medium),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            e.isActive ? 'Active' : 'Disactive',
                            style: AppStyles.medium.copyWith(
                              color:
                                  e.isActive ? AppColors.primary : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
