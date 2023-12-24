import 'package:flutter/material.dart';
import 'package:grocery/data/models/product_type.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';

class ChooseProductTypeDialog extends StatefulWidget {
  final List<ProductType> productTypes;

  const ChooseProductTypeDialog({
    super.key,
    required this.productTypes,
  });

  @override
  State<ChooseProductTypeDialog> createState() =>
      _ChooseProductTypeDialogState();
}

class _ChooseProductTypeDialogState extends State<ChooseProductTypeDialog> {
  bool isActive = true;
  ProductType? selectedProductType;

  @override
  void initState() {
    super.initState();
    selectedProductType = widget.productTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      clipBehavior: Clip.hardEdge,
      title: Container(
        width: 400,
        padding: const EdgeInsets.only(
          bottom: 10,
          top: 10,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select a product type', style: AppStyles.medium),
            const SizedBox(height: 20),
            comboBox(widget.productTypes, (p0) {
              setState(() {
                selectedProductType = p0;
              });
            }, selectedProductType),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildButton(
                    title: 'Back',
                    callback: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                    borderColor: AppColors.box.withOpacity(0.5),
                    textColor: AppColors.black,
                  ),
                  const SizedBox(width: 10),
                  _buildButton(
                    title: 'Confirm',
                    callback: () {
                      Navigator.of(context).pop(selectedProductType);
                    },
                    color: isActive
                        ? Colors.black
                        : AppColors.textGray999.withOpacity(0.3),
                    textColor: isActive ? Colors.white : Colors.black,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget comboBox(
      List<dynamic> source, Function(dynamic)? callback, dynamic value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.gray,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          isExpanded: true,
          value: value,
          style: AppStyles.medium,
          dropdownColor: Colors.white,
          items: source
              .map(
                (e) => DropdownMenuItem<dynamic>(
                  value: e,
                  child: Text(
                    '${e.name}',
                    style: AppStyles.medium,
                  ),
                ),
              )
              .toList(),
          onChanged: callback,
        ),
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required VoidCallback callback,
    required Color color,
    Color? borderColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null
              ? Border.all(
                  width: 1,
                  color: borderColor,
                )
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.semibold.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
