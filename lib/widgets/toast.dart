import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Widgets {
  static void showToast(error) {
    Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      textColor: Colors.white,
      backgroundColor: Colors.red,
      fontSize: 16,
    );
  }
}
