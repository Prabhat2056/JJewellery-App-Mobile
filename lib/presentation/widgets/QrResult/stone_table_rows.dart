import 'package:flutter/material.dart';

Widget stoneTableRows({
  required TextEditingController nameController,
  required TextEditingController weightController,
  required TextEditingController priceController,
  required Function(String) onNameChanged,
  required Function(String) onWeightChanged,
  required Function(String) onPriceChanged,
  required Function(String?) nameValidator,
  required Function(String?) weightValidator,
  required Function(String?) priceValidator,
  // required bool isReadOnly,
}) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: TextFormField(
          controller: nameController,
          // readOnly: isReadOnly,
          validator: (value) => nameValidator(value),
          keyboardType: TextInputType.text,
          onChanged: onNameChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 10.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      const SizedBox(width: 13),
      Expanded(
        flex: 1,
        child: TextFormField(
          // readOnly: isReadOnly,
          controller: weightController,
          validator: (value) => weightValidator(value),
          keyboardType: TextInputType.number,
          onChanged: onWeightChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 10.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      const SizedBox(width: 13),
      Expanded(
        flex: 1,
        child: TextFormField(
          // readOnly: isReadOnly,
          controller: priceController,
          keyboardType: TextInputType.number,
          validator: (value) => priceValidator(value),
          onChanged: onPriceChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 10.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    ],
  );
}
