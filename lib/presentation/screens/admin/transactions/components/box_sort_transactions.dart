import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/admin/transaction_bloc/transaction_bloc.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class BoxSortTransactions extends StatefulWidget {
  const BoxSortTransactions({
    super.key,
  });

  @override
  State<BoxSortTransactions> createState() => _BoxSortTransactionsState();
}

class _BoxSortTransactionsState extends State<BoxSortTransactions> {
  TransactionBloc get _bloc => BlocProvider.of<TransactionBloc>(context);

  String itemChecked = '';

  final List<String> sorts = ['Nearest Date', 'Farest Date'];

  @override
  void initState() {
    super.initState();
    itemChecked = _bloc.sort;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sort', style: AppStyles.bold.copyWith(fontSize: 21)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var sortItem = sorts[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      itemChecked = sortItem;
                    });
                  },
                  child: itemSort(
                    sortItem,
                    itemChecked == sortItem,
                  ),
                );
              },
              itemCount: sorts.length,
            ),
          ),
          CustomButton(
            content: 'Submit',
            margin: 0,
            onTap: () {
              _bloc.add(TransactionSorted(sortValue: itemChecked));
              Navigator.pop(context, itemChecked);
            },
          ),
        ],
      ),
    );
  }

  Widget itemSort(String prop, bool isChecked) {
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
