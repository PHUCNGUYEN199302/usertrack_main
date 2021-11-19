import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ButtonCustom extends StatefulWidget {
  final GestureTapCallback onPressed;
  final String text;

  ButtonCustom({
    required this.onPressed,
    required this.text,
  });

  @override
  _ButtonCustomState createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlue,
        onPrimary: Colors.white,
        shadowColor: Colors.red,
        elevation: 5,
      ),
      onPressed: widget.onPressed,
      child: Text(widget.text),
    );
  }





}

