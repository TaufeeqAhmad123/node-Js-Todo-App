import 'dart:ui';

import 'package:flutter/material.dart' hide Size;
import 'package:flutter_svg/svg.dart';
import 'package:todo_nodejs/screen/signup.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  String? Function(String?)? validator;
  final String hint, lableText, icon;

   TextFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    required this.lableText,
    required this.icon,
     this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (email) {},
      onChanged: (email) {},
      validator: validator,
      textInputAction: TextInputAction.next,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: lableText,

        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(color: Color(0xFF757575)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),

        suffix: SvgPicture.string(icon),
        border: authOutlineInputBorder,
        enabledBorder: authOutlineInputBorder,
        focusedBorder: authOutlineInputBorder.copyWith(
          borderSide: const BorderSide(color: Color(0xFFFF7643)),
        ),
      ),
    );
  }
}
