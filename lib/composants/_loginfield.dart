import "package:flutter/material.dart";

class MyLoginField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyLoginField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            fillColor: Color.fromARGB(255, 202, 195, 214),
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white)));
  }
}
