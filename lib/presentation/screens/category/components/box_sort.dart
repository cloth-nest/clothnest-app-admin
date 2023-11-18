import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/services/user/category_detail_bloc/category_detail_bloc.dart';
import 'package:grocery/presentation/widgets/custom_button.dart';

class BoxSort extends StatefulWidget {
  const BoxSort({
    super.key,
  });

  @override
  State<BoxSort> createState() => _BoxSortState();
}

class _BoxSortState extends State<BoxSort> {
  CategoryDetailBloc get _bloc => BlocProvider.of<CategoryDetailBloc>(context);

  String itemChecked = '';

  final List<String> sorts = ['Lowest Price', 'Highest Price'];

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
              _bloc.add(CategoryDetailProductsSorted(type: itemChecked));
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
