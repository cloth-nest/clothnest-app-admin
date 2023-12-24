import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/style.dart';
import 'package:grocery/presentation/widgets/text_field_input.dart';

class AddProductTypeDialog extends StatefulWidget {
  final TextEditingController controller;

  const AddProductTypeDialog({
    super.key,
    required this.controller,
  });

  @override
  State<AddProductTypeDialog> createState() => _AddProductTypeDialogState();
}

class _AddProductTypeDialogState extends State<AddProductTypeDialog> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      clipBehavior: Clip.hardEdge,
      title: Container(
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
            Text('Create new product type', style: AppStyles.medium),
            const SizedBox(height: 20),
            SizedBox(
              width: 500,
              child: TextFieldInput(
                controller: widget.controller,
                hintText: 'Product Type Name',
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    setState(() {
                      isActive = true;
                    });
                  }
                },
              ),
            ),
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
                    title: 'Save',
                    callback: () {
                      Navigator.of(context).pop(widget.controller.text.trim());
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
