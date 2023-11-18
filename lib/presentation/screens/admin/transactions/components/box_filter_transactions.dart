import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/transaction_bloc/transaction_bloc.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class BoxFilterTransactions extends StatefulWidget {
  const BoxFilterTransactions({super.key});

  @override
  State<BoxFilterTransactions> createState() => _BoxFilterTransactionsState();
}

class _BoxFilterTransactionsState extends State<BoxFilterTransactions> {
  TransactionBloc get _bloc => BlocProvider.of<TransactionBloc>(context);
  final List<String> statuses = ['Finished', 'In Progress', 'Cancelled', 'All'];
  List<String> values = [];

  @override
  void initState() {
    super.initState();
    values = _bloc.filterStatuses;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter', style: AppStyles.bold.copyWith(fontSize: 21)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var filterItem = statuses[index];
                return GestureDetector(
                  onTap: () {
                    if (values.contains(filterItem)) {
                      values.removeWhere((e) => e == filterItem);
                      setState(() {});
                    } else {
                      setState(() {
                        values.add(filterItem);
                      });
                    }
                  },
                  child: itemFilter(
                    filterItem,
                    values.contains(filterItem),
                  ),
                );
              },
              itemCount: statuses.length,
            ),
          ),
          CustomButton(
            content: 'Submit',
            margin: 0,
            onTap: () {
              _bloc.add(TransactionFiltered(filterValues: values));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget itemFilter(String prop, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          Text(
            prop,
            style: AppStyles.medium,
          ),
          const Spacer(),
          if (isChecked)
            const Icon(
              Icons.check,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }
}
