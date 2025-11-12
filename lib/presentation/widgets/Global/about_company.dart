import 'package:flutter/material.dart';

import '../../../utils/color_constant.dart';

Widget buildContactInfo({required bool isQr}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      buildText("** Please contact Matrika Technology Pvt. Ltd. **",
          textSize: isQr ? 9 : 10),
      buildText(
        isQr ? "for valid qr code" : "If you don't have an account",
        textSize: 9,
      ),
      const SizedBox(height: 2),
      Divider(color: ColorConstant.primaryColor),
      const SizedBox(height: 2),
      buildText("info@matrikatec.com.np",
          color: ColorConstant.primaryColor, textSize: 12),
      buildText("9852044102 | 9811346311 | 01-5925122",
          color: ColorConstant.primaryColor, textSize: 12),
    ],
  );
}

Widget buildText(String title,
    {double textSize = 12,
    Color color = const Color.fromARGB(255, 187, 66, 57)}) {
  return Text(
    title,
    style: TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: textSize,
    ),
    textAlign: TextAlign.center,
  );
}
