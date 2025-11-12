import 'package:flutter/material.dart';

import '../../../utils/color_constant.dart';

Widget filledIcon({required icon}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: ColorConstant.primaryColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(
      icon,
      size: 24,
      color: Colors.white,
    ),
  );
}
