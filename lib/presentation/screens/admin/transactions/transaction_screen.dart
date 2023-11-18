import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/admin/transactions/components/item_transaction.dart';
import 'package:grocery/presentation/screens/admin/transactions/components/sort_filter_transactions.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
        title: Text(
          'Transactions',
          style: AppStyles.bold.copyWith(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return LoadingScreen().showLoadingWidget();
          } else if (state is TransactionSuccess) {
            List<Order> orders = state.orders;

            return Stack(
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    Order order = orders[index];
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TransactionDetailScreen(
                              order: order,
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
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: SortFilterTransactions(),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
