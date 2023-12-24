import 'package:flutter/material.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';

class ItemProduct extends StatelessWidget {
  final Product product;

  const ItemProduct({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // // image
        // Expanded(
        //   child: Image.network(
        //     product.productImgList![0].imgUrl,
        //     alignment: Alignment.center,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        // const SizedBox(height: 10),
        // // name
        // Text(
        //   product.productName,
        //   style: AppStyles.medium,
        // ),
        // // unit
        // Text(
        //   product.unit,
        //   style: AppStyles.regular.copyWith(color: AppColors.gray),
        // ),
        // const SizedBox(height: 5),
        // // original price
        // Text(
        //   '\$${product.price}',
        //   style: product.discount != 0
        //       ? AppStyles.regular.copyWith(
        //           fontSize: 15,
        //           decoration: TextDecoration.lineThrough,
        //           color: AppColors.text,
        //         )
        //       : AppStyles.medium.copyWith(
        //           color: AppColors.secondary,
        //           fontSize: 17,
        //         ),
        // ),
        // const SizedBox(height: 5),
        // if (product.discount != 0)
        //   Text(
        //     '\$${product.price * (100 - product.discount) * 0.01}',
        //     style: AppStyles.medium.copyWith(
        //       color: AppColors.secondary,
        //       fontSize: 17,
        //     ),
        //   ),
      ],
    );
  }
}
