import 'package:flutter/material.dart';

class Helpers {
  const Helpers._();

  static void showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}