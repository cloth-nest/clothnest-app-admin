import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BoxSearch extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String) callback;
  const BoxSearch({
    super.key,
    required this.controller,
    required this.hintText,
    this.contentPadding,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        callback(value);
      },
      decoration: InputDecoration(
        contentPadding: contentPadding,
        fillColor: const Color.fromARGB(255, 240, 239, 239),
        filled: true,
        hintText: hintText,
        suffixIcon: const Icon(
          FontAwesomeIcons.magnifyingGlass,
          size: 18,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}
