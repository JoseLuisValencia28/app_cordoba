import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  getDialog({String? mensaje, Color? color}) {
    return Fluttertoast.showToast(
      msg: mensaje.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 4,
      backgroundColor: (color == null) ? Colors.red : color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
