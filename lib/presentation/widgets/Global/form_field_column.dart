import 'package:flutter/material.dart';

Widget formFieldColumn({
  required String label,
  Function(String?)? validator,
  Function(String)? onChange,
  TextEditingController? controller,
  String? initialValue,
  Color color = Colors.black,
  bool isEnabled = true,
  bool isNumber = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$label:",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        validator: validator != null ? (value) => validator(value) : null,
        onChanged: onChange != null ? (value) => onChange(value) : null,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        enabled: isEnabled,
        controller: controller,
        initialValue: initialValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    ],
  );
}
