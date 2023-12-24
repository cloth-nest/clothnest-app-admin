import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/user/product_detail_bloc/product_detail_bloc.dart';
import 'package:grocery/presentation/utils/functions.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:grocery/presentation/widgets/icon_edit_cart.dart';

class BoxAddToCart extends StatefulWidget {
  final Product product;

  const BoxAddToCart({
    super.key,
    required this.product,
  });

  @override
  State<BoxAddToCart> createState() => _BoxAddToCartState();
}

class _BoxAddToCartState extends State<BoxAddToCart> {
  int quantity = 0;
  ProductDetailBloc get _bloc => BlocProvider.of<ProductDetailBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Image.network(
          //       widget.product.productImgList![0].imgUrl,
          //       width: 150,
          //       height: 150,
          //       fit: BoxFit.cover,
          //     ),
          //     const SizedBox(width: 10),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Wrap(
          //             children: [
          //               Text(
          //                 widget.product.productName,
          //                 style: AppStyles.medium.copyWith(
          //                   fontSize: 16,
          //                 ),
          //               ),
          //             ],
          //           ),
          //           widget.product.discount == 0
          //               ? Text(
          //                   '\$${widget.product.price}',
          //                   textAlign: TextAlign.end,
          //                   style: AppStyles.medium.copyWith(
          //                     color: AppColors.secondary,
          //                   ),
          //                 )
          //               : Text(
          //                   '\$${widget.product.price * (100 - widget.product.discount) * 0.01}',
          //                   style: AppStyles.medium.copyWith(
          //                     color: AppColors.secondary,
          //                   ),
          //                 ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('Quantity', style: AppStyles.medium.copyWith(fontSize: 15)),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconEditCart(
                    child: const Positioned(
                      bottom: 7,
                      child: Icon(
                        Icons.minimize,
                        size: 17,
                        color: AppColors.primary,
                      ),
                    ),
                    callback: () {
                      if (quantity > 0) {
                        setState(() {
                          --quantity;
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Text('$quantity', style: AppStyles.bold),
                  const SizedBox(width: 10),
                  IconEditCart(
                    child: const Icon(
                      Icons.add,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    callback: () {
                      setState(() {
                        ++quantity;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          // CustomButton(
          //   content: 'Add To Cart',
          //   margin: 0,
          //   onTap: () {
          //     _bloc.add(
          //       ProductAddedToCart(
          //         idProduct: widget.product.id!,
          //         quantity: quantity,
          //       ),
          //     );
          //     Navigator.pop(context);
          //     showSnackBar(
          //       context,
          //       'Add to cart successfully',
          //       const Icon(Icons.check, color: Colors.white),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
