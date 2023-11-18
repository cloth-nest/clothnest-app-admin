import 'package:flutter/material.dart';
import 'package:grocery/data/models/product.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/address/address_screen.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';

class ReviewOrderScreen extends StatelessWidget {
  const ReviewOrderScreen({super.key});

  navigateToAddressScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddressScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> carts = [];
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Your Order',
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Text(
              'Order List',
              style: AppStyles.regular,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // Product product = carts[index];
                // return ItemReviewOrder(product: product);
              },
              itemCount: carts.length,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Total',
                  style: AppStyles.bold,
                ),
                const Spacer(),
                Text(
                  '\$23.00',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Deliver to',
                  style: AppStyles.regular,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => navigateToAddressScreen(context),
                  child: Text(
                    'Change',
                    style: AppStyles.regular.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
