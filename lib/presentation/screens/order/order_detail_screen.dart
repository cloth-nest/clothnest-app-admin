import 'package:flutter/material.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/order/components/item_tag_order.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          'Transaction Detail',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ItemTagOrder(status: order.status!),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Transaction ID',
                        style: AppStyles.medium.copyWith(
                          fontSize: 15,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          order.id!,
                          style: AppStyles.medium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.text),
                  Row(
                    children: [
                      Text(
                        'Customer',
                        style: AppStyles.medium.copyWith(
                          fontSize: 15,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(order.address!.name, style: AppStyles.medium),
                    ],
                  ),
                  const Divider(color: AppColors.text),
                  Row(
                    children: [
                      Text(
                        'Order Date',
                        style: AppStyles.medium.copyWith(
                          fontSize: 15,
                          color: AppColors.text.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(
                          DateFormat('dd/MM/yyyy HH:MM')
                              .format(DateTime.parse(order.createdAt!)),
                          style: AppStyles.medium),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Address',
                    style: AppStyles.medium.copyWith(
                      color: AppColors.text.withOpacity(0.7),
                    ),
                  ),
                  Text(order.address!.name, style: AppStyles.medium),
                  Text(order.address!.detail, style: AppStyles.medium),
                  Text(
                      '${order.address!.districtName}, ${order.address!.provinceName}',
                      style: AppStyles.medium),
                  Text(order.address!.phoneNum, style: AppStyles.medium),
                  const SizedBox(height: 10),
                  Wrap(
                    direction: Axis.vertical,
                    spacing: 5,
                    children: order.orderDetailList!
                        .map((e) => Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    e['product'].thumbnail!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e['product'].productName,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.medium
                                          .copyWith(fontSize: 14),
                                    ),
                                    Row(
                                      children: [
                                        Text('Quantity: ',
                                            style: AppStyles.regular),
                                        Text(e['quantity'].toString(),
                                            style: AppStyles.medium.copyWith(
                                              fontSize: 14,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Price: ',
                                            style: AppStyles.regular),
                                        Text('\$ ${e['price'].toString()}',
                                            style: AppStyles.medium.copyWith(
                                              fontSize: 14,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                  const Divider(color: AppColors.text),
                  Row(
                    children: [
                      Text('Quantity', style: AppStyles.medium),
                      const Spacer(),
                      Text(order.totalQuantity.toString(),
                          style: AppStyles.medium),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Sub Total', style: AppStyles.medium),
                      const Spacer(),
                      Text(
                        '\$ ${(order.total! - 2).toString()}',
                        style: AppStyles.medium,
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Text('Discount', style: AppStyles.medium),
                  //     const Spacer(),
                  //     Text('\$5', style: AppStyles.medium),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Text('Delivery Fee', style: AppStyles.medium),
                      const Spacer(),
                      Text('\$ ${order.shippingFee}', style: AppStyles.medium),
                    ],
                  ),
                  const Divider(color: AppColors.text),
                  Row(
                    children: [
                      Text('Total Payment', style: AppStyles.bold),
                      const Spacer(),
                      Text('\$ ${order.total}', style: AppStyles.bold),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
