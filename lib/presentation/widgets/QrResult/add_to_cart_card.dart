import 'package:flutter/material.dart';

Widget addToCartCard({
  required double width,
  required VoidCallback onTap,
  required String title,
  Color bgColor = const Color.fromARGB(255, 3, 72, 72),
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width * 0.9,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          )),
    ),
  );
}
