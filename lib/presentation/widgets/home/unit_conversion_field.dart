import 'package:flutter/material.dart';
import 'package:jjewellery/presentation/widgets/Global/single_dot_formatter.dart';

import '../../../utils/color_constant.dart';

Widget unitConversionField(
    {required String title,
    required TextEditingController controller,
    required Function(String) onChanged,
    Color color = Colors.white}) {
  return Flexible(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          inputFormatters: [SingleDotFormatter()],
          controller: controller,
          onTap: () {
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          },
          keyboardType: TextInputType.number,
          autofocus: false,
          decoration: InputDecoration(
            fillColor: ColorConstant.scaffoldColor,
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          onChanged: (value) => onChanged(value),
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}
