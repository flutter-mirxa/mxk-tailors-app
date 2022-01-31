import 'package:flutter/material.dart';

void showMsgToBottom(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "" + msg,
      style: const TextStyle(
        fontSize: 18.0,
        color: Colors.white,
      ),
    ),
    backgroundColor: const Color(0xff4c505b),
  ));
}
