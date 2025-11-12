import 'package:flutter/material.dart';

import '../../../utils/color_constant.dart';
import '../Global/custom_buttons.dart';
import '../QrResult/row_with_textfield.dart';

ListTile customListTile(
    {required String title,
    VoidCallback? onTap,
    IconData? icon,
    Widget? trailing}) {
  return ListTile(
    leading: Icon(
      icon,
      color: ColorConstant.primaryColor,
      size: 19,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: ColorConstant.primaryColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    onTap: onTap,
    trailing: trailing,
  );
}

Widget customSettingBox({
  required context,
  TextEditingController? controller,
  key,
  required title,
  required VoidCallback onPressed,
  Function(String)? onChanged,
  String? initialValue,
  String? warnings,
  String? label1,
  String? label2,
  TextEditingController? label1Controller,
  TextEditingController? label2Controller,
  bool twoTextFields = false,
}) {
  return AlertDialog(
    backgroundColor: ColorConstant.scaffoldColor,
    content: SizedBox(
      height: twoTextFields ? 230 : 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorConstant.primaryColor),
          ),
          twoTextFields
              ? Form(
                  child: Column(
                  children: [
                    rowWithTextField(
                      controller: label1Controller,
                      title: label1!,
                      width: 50,
                      isUnitLeading: false,
                      isNumberField: true,
                    ),
                    rowWithTextField(
                      controller: label2Controller,
                      title: label2!,
                      width: 50,
                      isUnitLeading: false,
                      isNumberField: true,
                    )
                  ],
                ))
              : Form(
                  key: key,
                  child: TextFormField(
                    controller: controller,
                    onChanged: onChanged,
                    initialValue: initialValue,
                    validator: (value) {
                      if (value!.isNotEmpty) return null;
                      return "Please enter value";
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 110, 108, 108),
                        ),
                      ),
                    ),
                  ),
                ),
          warnings != null
              ? Center(
                  child: Text(
                    warnings,
                    style: TextStyle(
                      color: ColorConstant.errorColor,
                      fontSize: 12,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Center(
              child: customElevatedButton(title: "Save", onPressed: onPressed)),
        ],
      ),
    ),
  );
}
