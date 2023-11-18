import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/order/components/item_tag_order.dart';
import 'package:grocery/presentation/services/admin/transaction_detail_bloc/transaction_detail_bloc.dart';
import 'package:grocery/presentation/widgets/custom_app_bar.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Order order;

  const TransactionDetailScreen({
    super.key,
    required this.order,
  });

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  TransactionDetailBloc get _bloc =>
      BlocProvider.of<TransactionDetailBloc>(context);

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
      body: BlocListener<TransactionDetailBloc, TransactionDetailState>(
        listener: (context, state) {
          if (state is TransactionDetailLoading) {
            LoadingScreen().show(context: context);
          } else if (state is TransactionDetailSuccess) {
            LoadingScreen().hide();
            Navigator.of(context).pop(true);
          } else if (state is TransactionDetailFailure) {
            LoadingScreen().hide();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ItemTagOrder(status: widget.order.status!),
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
                            widget.order.id!,
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
                        Text(widget.order.address!.name,
                            style: AppStyles.medium),
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
                            DateFormat('dd/MM/yyyy HH:MM').format(
                                DateTime.parse(widget.order.createdAt!)),
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
                    Text(widget.order.address!.name, style: AppStyles.medium),
                    Text(widget.order.address!.detail, style: AppStyles.medium),
                    Text(
                        '${widget.order.address!.districtName}, ${widget.order.address!.provinceName}',
                        style: AppStyles.medium),
                    Text(widget.order.address!.phoneNum,
                        style: AppStyles.medium),
                    const SizedBox(height: 10),
                    Wrap(
                      direction: Axis.vertical,
                      spacing: 5,
                      children: widget.order.orderDetailList!
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        Text('2', style: AppStyles.medium),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Sub Total', style: AppStyles.medium),
                        const Spacer(),
                        Text(
                          '\$ ${widget.order.total.toString()}',
                          style: AppStyles.medium,
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Text('Discount', style: AppStyles.medium),
                    //     const Spacer(),
                    //     Text('\', style: AppStyles.medium),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Text('Delivery Fee', style: AppStyles.medium),
                        const Spacer(),
                        Text('\$ ${widget.order.shippingFee}',
                            style: AppStyles.medium),
                      ],
                    ),
                    const Divider(color: AppColors.text),
                    Row(
                      children: [
                        Text('Total Payment', style: AppStyles.bold),
                        const Spacer(),
                        Text('\$ ${widget.order.total}', style: AppStyles.bold),
                      ],
                    ),
                    if (widget.order.status != 'Finished' &&
                        widget.order.status != 'Cancelled') ...[
                      const SizedBox(height: 15),
                      CustomButton(
                        margin: 0,
                        content: 'Complete Order',
                        onTap: () {
                          _bloc.add(
                            TransactionDetailStatusChanged(
                              orderId: widget.order.id!,
                              newStatus: 'Finished',
                              email: widget.order.email!,
                            ),
                          );
                        },
                        color: const Color(0xFF08C25E),
                      ),
                      const SizedBox(height: 15),
                      CustomButton(
                        margin: 0,
                        content: 'Cancel Order',
                        onTap: () {
                          _bloc.add(
                            TransactionDetailStatusChanged(
                              orderId: widget.order.id!,
                              newStatus: 'Cancelled',
                              email: widget.order.email!,
                            ),
                          );
                        },
                        color: const Color(0xFFFF3030),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
