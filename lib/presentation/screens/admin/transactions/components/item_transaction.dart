import 'package:flutter/material.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/data/models/order_model.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/order/components/item_tag_order.dart';
import 'package:intl/intl.dart';

class ItemTransaction extends StatelessWidget {
  final OrderModel order;

  const ItemTransaction({
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
                DateFormat('dd/MM/yyyy HH:MM')
                    .format(DateTime.parse(order.createdAt!)),
                style: AppStyles.regular.copyWith(
                  color: AppColors.gray,
                  fontSize: 15,
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          itemRow('Transaction ID', order.id.toString()),
          itemRow('User', '${order.firstName} ${order.lastName}'),
          itemRow('Total Payment', '\$ ${order.total.toString()}'),
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
