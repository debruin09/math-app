import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  static final themeColor = Colors.white;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: callback,
      color: themeColor,
    );
  }
}
