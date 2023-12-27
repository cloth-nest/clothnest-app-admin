import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/order_model.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/transactions/components/item_transaction.dart';
import 'package:grocery/presentation/screens/admin/transactions/transaction_detail_screen.dart';
import 'package:grocery/presentation/services/admin/transaction_bloc/transaction_bloc.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TransactionBloc get _bloc => BlocProvider.of<TransactionBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(TransactionStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return LoadingScreen().showLoadingWidget();
          } else if (state is TransactionSuccess) {
            List<OrderModel> orders = state.orders;

            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transactions',
                          style: AppStyles.semibold,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Import Order',
                            style: AppStyles.medium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        OrderModel order = orders[index];
                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TransactionDetailScreen(
                                  orderId: order.id,
                                ),
                              ),
                            );
                            if (result == true) {
                              _bloc.add(TransactionStarted());
                            }
                          },
                          child: ItemTransaction(
                            order: order,
                          ),
                        );
                      },
                      itemCount: orders.length,
                    ),
                  ),
                  // const Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(bottom: 30.0),
                  //     child: SortFilterTransactions(),
                  //   ),
                  // ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
