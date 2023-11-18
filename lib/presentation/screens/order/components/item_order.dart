import 'package:flutter/material.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/review/review_order_screen.dart';
import 'package:grocery/presentation/screens/order/components/item_tag_order.dart';
import 'package:intl/intl.dart';

class ItemOrder extends StatelessWidget {
  final Order order;
  const ItemOrder({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ItemTagOrder(status: order.status!),
              const Spacer(),
              Text(
                DateFormat('dd/MM/yyyy HH:MM').format(
                  DateTime.parse(order.createdAt!).toLocal(),
                ),
                style: AppStyles.regular.copyWith(
                  color: AppColors.gray,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          itemRow('Transaction ID', order.id!),
          if (order.status == "Finished") const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    itemRow('User', order.address!.name),
                    itemRow('Total Payment', '\$ ${order.total.toString()}'),
                  ],
                ),
              ),
              order.status == "Finished"
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ReviewOrderScreen(
                              order: order,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          'Review',
                          textAlign: TextAlign.center,
                          style: AppStyles.semibold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }

  Widget itemRow(String key, String value) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$key: ',
          style: AppStyles.regular,
          softWrap: true,
        ),
        const SizedBox(height: 5),
        Flexible(
          child: Text(
            value,
            style: AppStyles.medium,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
