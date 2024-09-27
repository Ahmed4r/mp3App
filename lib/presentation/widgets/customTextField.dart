import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  String message ;
  TextEditingController? controller;

  Customtextfield({required this.controller,required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 390,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(30)),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return message;
            }
        },
        showCursor: true,
        controller: controller,
      ),
    );
  }
}
