// import 'package:flutter/material.dart';

// import '../../../utils/color_constant.dart';

// Widget qrKeyField({
//   required TextEditingController controller,
//   required FocusNode focusNode,
//   required Function(String?) onChanged,
//   required bool isQrEmpty,
// }) {
//   return SizedBox(
//     width: 45,
//     height: 45,
//     child: TextField(
//       controller: controller,
//       focusNode: focusNode,
//       maxLength: 1,
//       textAlign: TextAlign.center,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         counterText: "",
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(
//             color: ColorConstant.primaryColor,
//             width: 1.5,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(
//               color: (controller.text.isEmpty && isQrEmpty)
//                   ? ColorConstant.errorColor
//                   : const Color.fromARGB(255, 110, 108, 108)),
//         ),
//       ),
//       onChanged: onChanged,
//     ),
//   );
// }
