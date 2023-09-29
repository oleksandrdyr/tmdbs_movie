import 'package:flutter/material.dart';

class AppButtonStyle {
  static final ButtonStyle linkBUtton = ButtonStyle(
      foregroundColor: MaterialStateProperty.all(const Color(0xFF01B4E4)),
      textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ));
}
