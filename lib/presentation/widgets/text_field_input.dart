import 'package:flutter/material.dart';
import 'package:grocery/presentation/res/colors.dart';
import 'package:grocery/presentation/res/images.dart';
import 'package:grocery/presentation/res/style.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPass;
  final TextInputType type;
  final Widget? prefixIcon;
  final bool? isEnabled;
  final int? maxLines;

  const TextFieldInput(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isPass = false,
      this.type = TextInputType.text,
      this.prefixIcon,
      this.isEnabled = true,
      this.maxLines = 1});

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isPass;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.type,
      maxLines: widget.maxLines,
      enabled: widget.isEnabled,
      controller: widget.controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPass
            ? InkWell(
                onTap: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                child: isObscure
                    ? Image.asset(AppAssets.icEye)
                    : Image.asset(AppAssets.icEyeOff),
              )
            : null,
        labelStyle: AppStyles.regular,
        labelText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: AppColors.gray,
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1,
          ),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your ${widget.hintText.toLowerCase()}';
        }

        return null;
      },
    );
  }
}
