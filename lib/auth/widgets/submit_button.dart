import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final String fontFamily;
  final double fontSize;
  final Color color;
  final double width;
  SubmitButton({
    Key key,
    this.onPressed,
    this.text,
    this.fontFamily,
    this.fontSize,
    this.color,
    this.width,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 55.0,
      minWidth: width,
      color: color,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
              color: Colors.white, width: 2.0, style: BorderStyle.solid)),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontFamily: fontFamily, fontSize: fontSize),
      ),
    );
  }
}
