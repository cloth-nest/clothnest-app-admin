import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/data/models/order.dart';
import 'package:grocery/presentation/helper/loading/loading_screen.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/screens/order/components/item_order.dart';
import 'package:grocery/presentation/screens/order/order_detail_screen.dart';
import 'package:grocery/presentation/services/user/order_bloc/order_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderBloc get _bloc => BlocProvider.of<OrderBloc>(context);

  @override
  void initState() {
    super.initState();
    _bloc.add(OrderStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        title: Text(
          'Order',
          style: AppStyles.bold.copyWith(
            fontSize: 19,
          ),
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return LoadingScreen().showLoadingWidget();
          } else if (state is OrderSuccess) {
            List<Order> orders = state.orders;

            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderDetailScreen(
                          order: orders[index],
                        ),
                      ),
                    );
                  },
                  child: ItemOrder(
                    order: orders[index],
                  ),
                );
              },
              itemCount: orders.length,
            );
          }
          return Center(
            child: Text('Order'),
          );
        },
      ),
    );
    ;
  }
}
