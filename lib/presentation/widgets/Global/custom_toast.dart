import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

customToast(String message, color) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: color,
    textColor: Colors.white,
    gravity: ToastGravity.CENTER,
    fontSize: 16.0,
    fontAsset: "assets/fonts/Quicksand-Regular.ttf",
  );
}
