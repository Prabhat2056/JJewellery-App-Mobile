import 'package:flutter/material.dart';

Widget refreshIndicator() {
  return Center(
    child: Container(
      height: 80,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
