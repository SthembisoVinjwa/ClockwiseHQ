import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final bool obscureText;
  final String hintText;
  final String? Function(String?)? validateField;

  const MyTextField(
      {Key? key, required this.controller, required this.obscureText, required this.hintText, required this.validateField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,),
      child: TextFormField(
        validator: validateField,
        cursorColor: Colors.indigoAccent,
        style: TextStyle(color: Colors.grey),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      ),
    );
  }
}
