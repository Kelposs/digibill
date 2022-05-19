import 'package:email_validator/email_validator.dart';
import 'package:final_project/components/text_field_container.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  static TextEditingController emailController = TextEditingController();
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: TextFieldContainer(
        child: TextFormField(
          validator: (value) => EmailValidator.validate(value!)
              ? null
              : "Please enter a valid email",
          onChanged: widget.onChanged,
          controller: RoundedInputField.emailController,
          decoration: InputDecoration(
              icon: Icon(widget.icon, color: kPrimaryColor),
              hintText: widget.hintText,
              border: InputBorder.none),
        ),
      ),
    );
  }
}
