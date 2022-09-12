import 'package:flutter/material.dart';
import 'package:udemy_todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.label, required this.ontap})
      : super(key: key);
  final String label;
  final Function() ontap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ontap,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      style: ElevatedButton.styleFrom(
          primary: primaryClr,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
