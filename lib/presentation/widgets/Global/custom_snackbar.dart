import 'package:flutter/material.dart';

SnackBar customSnackBar(String message, color) {
  return SnackBar(
    behavior: SnackBarBehavior.fixed,
    content: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    duration: const Duration(seconds: 2),
  );
}
