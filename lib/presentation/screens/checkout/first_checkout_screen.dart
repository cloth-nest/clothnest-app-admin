import 'package:flutter/material.dart';
import 'package:grocery/data/models/cart.dart';
import 'package:grocery/data/models/payment.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/checkout/components/item_payment_method.dart';
import 'package:grocery/presentation/screens/checkout/second_checkout_screen.dart';
import 'package:grocery/presentation/utils/money_extension.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class FirstCheckOutScreen extends StatefulWidget {
  final double orderTotal;
  final List<Cart> carts;
  final bool isFromCart;

  const FirstCheckOutScreen({
    super.key,
    required this.orderTotal,
    required this.carts,
    required this.isFromCart,
  });

  @override
  State<FirstCheckOutScreen> createState() => _FirstCheckOutScreenState();
}

class _FirstCheckOutScreenState extends State<FirstCheckOutScreen> {
  // List<Payment> payments = [
  //   Payment(
  //     img: AppAssets.icCash,
  //     name: 'Payment By Cash',
  //   ),
  //   Payment(
  //     img: AppAssets.icCash,
  //     name: 'Payment By Zalo Pay',
  //   )
  // ];
  // String namePayment = "Payment By Cash";

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 2;
    double vatFee = 0.1 * widget.orderTotal;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Payment',
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Text(
                  'Order Total',
                  style: AppStyles.regular,
                ),
                const Spacer(),
                Text(
                  widget.orderTotal.toDouble().toMoney,
                  style: AppStyles.regular,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Text(
                  'Deliver Fee',
                  style: AppStyles.regular,
                ),
                const Spacer(),
                Text(
                  deliveryFee.toDouble().toMoney,
                  style: AppStyles.regular,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Text(
                  'VAT (10%)',
                  style: AppStyles.regular,
                ),
                const Spacer(),
                Text(
                  vatFee.toMoney,
                  style: AppStyles.regular,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Total Payment',
                  style: AppStyles.bold,
                ),
                const Spacer(),
                Text(
                  (widget.orderTotal + vatFee + deliveryFee).toMoney,
                  style: AppStyles.bold,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 3,
            color: const Color(0xFFEEEEEE),
          ),
          const SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Text(
          //     'Choose Payment Method',
          //     style: AppStyles.medium,
          //   ),
          // ),
          // const SizedBox(height: 10),
          // SizedBox(
          //   width: double.infinity,
          //   child: Wrap(
          //     // spacing: 10,
          //     // direction: Axis.vertical,
          //     children: payments
          //         .map(
          //           (e) => GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 namePayment = e.name;
          //               });
          //             },
          //             child: ItemPaymentMethod(
          //               payment: e,
          //               isPicked: namePayment == e.name,
          //             ),
          //           ),
          //         )
          //         .toList(),
          //   ),
          // ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: ItemPaymentMethod(
          //     img: AppAssets.icCash,
          //     method: 'Payment By Cash',
          //     isPicked: true,
          //   ),
          // ),
          // const SizedBox(height: 5),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20),
          //   child: ItemPaymentMethod(
          //     img: AppAssets.icCash,
          //     method: 'Payment By Zalo Pay',
          //     isPicked: false,
          //   ),
          // ),
          const Spacer(),
          SafeArea(
            child: CustomButton(
              content: 'Checkout',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SecondCheckOutScreen(
                      carts: widget.carts,
                      orderTotal: widget.orderTotal,
                      isFromCart: widget.isFromCart,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
