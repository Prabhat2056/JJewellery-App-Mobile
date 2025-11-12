import 'package:flutter/material.dart';

ElevatedButton customElevatedButton(
    {required String title,
    required VoidCallback onPressed,
    bgColor = const Color.fromARGB(255, 3, 72, 72),
    fgColor = Colors.white}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}
