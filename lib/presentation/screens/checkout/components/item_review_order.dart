import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/cart.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/user/cart_bloc/cart_bloc.dart';
import 'package:grocery/presentation/utils/money_extension.dart';
import 'package:grocery/presentation/widgets/icon_edit_cart.dart';

class ItemReviewOrder extends StatefulWidget {
  final Cart cart;

  const ItemReviewOrder({
    super.key,
    required this.cart,
  });

  @override
  State<ItemReviewOrder> createState() => _ItemReviewOrderState();
}

class _ItemReviewOrderState extends State<ItemReviewOrder> {
  CartBloc get _bloc => BlocProvider.of<CartBloc>(context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      // child: Row(
      //   children: [
      //     Image.network(
      //       widget.cart.product.productImgList![0].imgUrl,
      //       fit: BoxFit.cover,
      //       width: 100,
      //       height: 100,
      //     ),
      //     const SizedBox(width: 10),
      //     Expanded(
      //       flex: 2,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             widget.cart.product.productName,
      //             style: AppStyles.medium.copyWith(
      //               fontSize: 14,
      //             ),
      //           ),
      //           const SizedBox(height: 1),
      //           widget.cart.product.discount == 0
      //               ? Text(
      //                   '\$${widget.cart.product.price} / ${widget.cart.product.unit}',
      //                   style: AppStyles.regular.copyWith(
      //                     fontSize: 12,
      //                   ),
      //                 )
      //               : Text(
      //                   '\$${widget.cart.product.price * (100 - widget.cart.product.discount) * 0.01} / ${widget.cart.product.unit}',
      //                   style: AppStyles.regular.copyWith(
      //                     fontSize: 12,
      //                   ),
      //                 ),
      //           const SizedBox(height: 5),
      //           BlocBuilder<CartBloc, CartState>(
      //             builder: (context, state) {
      //               if (state is CartLoaded) {
      //                 double price = 0;
      //                 price = widget.cart.product.discount == 0
      //                     ? (widget.cart.quantity * widget.cart.product.price)
      //                         .toDouble()
      //                     : widget.cart.quantity *
      //                         widget.cart.product.price *
      //                         (100 - widget.cart.product.discount) *
      //                         0.01;
      //                 return Text(
      //                   price.toMoney,
      //                   style: AppStyles.semibold.copyWith(
      //                     fontSize: 14,
      //                   ),
      //                 );
      //               }
      //               return const SizedBox();
      //             },
      //           ),
      //         ],
      //       ),
      //     ),
      //     BlocBuilder<CartBloc, CartState>(
      //       builder: (context, state) {
      //         if (state is CartLoaded) {
      //           return Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               IconEditCart(
      //                 child: const Positioned(
      //                   bottom: 7,
      //                   child: Icon(
      //                     Icons.minimize,
      //                     size: 17,
      //                     color: AppColors.primary,
      //                   ),
      //                 ),
      //                 callback: () {
      //                   _bloc.add(
      //                     CartRemoved(
      //                       cart: widget.cart,
      //                     ),
      //                   );
      //                 },
      //               ),
      //               const SizedBox(width: 10),
      //               Text('${widget.cart.quantity}', style: AppStyles.bold),
      //               const SizedBox(width: 10),
      //               IconEditCart(
      //                 child: const Icon(
      //                   Icons.add,
      //                   size: 17,
      //                   color: AppColors.primary,
      //                 ),
      //                 callback: () {
      //                   _bloc.add(
      //                     CartAdded(
      //                       cart: widget.cart,
      //                     ),
      //                   );
      //                 },
      //               ),
      //             ],
      //           );
      //         }
      //         return const SizedBox();
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
