import 'package:flutter/material.dart';

import '../../../utils/color_constant.dart';

Widget customErrorMessage(String message) {
  return Center(
    child: Column(
      children: [
        Text(
          message,
          style: TextStyle(
            color: ColorConstant.errorColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "**Please connect to server**",
          style: TextStyle(
            color: ColorConstant.errorColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}
