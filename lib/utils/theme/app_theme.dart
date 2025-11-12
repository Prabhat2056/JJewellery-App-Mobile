import 'package:flutter/material.dart';

import '../color_constant.dart';

class AppTheme {
  static ThemeData appTheme = ThemeData.light().copyWith(
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Quicksand',
          ),
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: ColorConstant.primaryColor,
            secondary: ColorConstant.primaryColor,
          ),
      focusColor: ColorConstant.primaryColor,
      scaffoldBackgroundColor: ColorConstant.scaffoldColor,
      dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
              fixedSize: WidgetStateProperty.all(const Size(10, 100)))));
}
