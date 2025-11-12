import 'package:flutter/material.dart';
import 'package:jjewellery/presentation/pages/splash.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_buttons.dart';

import 'package:jjewellery/utils/color_constant.dart';

import '../../main_common.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // bool isQrEmpty = false;

  TextEditingController ipController = TextEditingController();
  TextEditingController qrController = TextEditingController();

  // TextEditingController qrController1 = TextEditingController();
  // TextEditingController qrController2 = TextEditingController();
  // TextEditingController qrController3 = TextEditingController();
  // TextEditingController qrController4 = TextEditingController();

  // FocusNode qrFocus1 = FocusNode();
  // FocusNode qrFocus2 = FocusNode();
  // FocusNode qrFocus3 = FocusNode();
  // FocusNode qrFocus4 = FocusNode();

  // void jumpToNextField(
  //     TextEditingController currentController, FocusNode? nextFocusNode) {
  //   if (currentController.text.isNotEmpty) {
  //     FocusScope.of(context).requestFocus(nextFocusNode);
  //   }
  // }

  final initialSetUpKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/playstore.png",
                  height: 150,
                  width: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  "Welcome to JJewellery",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: initialSetUpKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        // Row(
                        //   children: [
                        //     Text(
                        //       "QR Key",
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 14,
                        //         color: ColorConstant.primaryColor,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 40),
                        // Expanded(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               qrKeyField(
                        //                 controller: qrController1,
                        //                 focusNode: qrFocus1,
                        //                 onChanged: (value) {
                        //                   if (value != null) {
                        //                     qrController1.text = value;
                        //                   }
                        //                   jumpToNextField(
                        //                       qrController1, qrFocus2);
                        //                 },
                        //                 isQrEmpty: isQrEmpty,
                        //               ),
                        //               qrKeyField(
                        //                   controller: qrController2,
                        //                   focusNode: qrFocus2,
                        //                   onChanged: (value) {
                        //                     if (value != null) {
                        //                       qrController2.text = value;
                        //                     }
                        //                     jumpToNextField(
                        //                         qrController2, qrFocus3);
                        //                   },
                        //                   isQrEmpty: isQrEmpty),
                        //               qrKeyField(
                        //                 controller: qrController3,
                        //                 focusNode: qrFocus3,
                        //                 onChanged: (value) {
                        //                   if (value != null) {
                        //                     qrController3.text = value;
                        //                   }
                        //                   jumpToNextField(
                        //                       qrController3, qrFocus4);
                        //                 },
                        //                 isQrEmpty: isQrEmpty,
                        //               ),
                        //               qrKeyField(
                        //                 controller: qrController4,
                        //                 focusNode: qrFocus4,
                        //                 onChanged: (value) {
                        //                   if (value != null) {
                        //                     qrController4.text = value;
                        //                   }
                        //                   jumpToNextField(qrController1, null);
                        //                 },
                        //                 isQrEmpty: isQrEmpty,
                        //               ),
                        //             ],
                        //           ),
                        //           isQrEmpty
                        //               ? Padding(
                        //                   padding:
                        //                       const EdgeInsets.only(top: 1),
                        //                   child: Text(
                        //                     "This field cannot be empty",
                        //                     style: TextStyle(
                        //                       color: ColorConstant.errorColor,
                        //                       fontSize: 12,
                        //                     ),
                        //                   ),
                        //                 )
                        //               : const SizedBox.shrink()
                        //         ],
                        //       ),
                        //     )
                        //   ],
                        // ),
                        customFields(
                          controller: qrController,
                          title: "QR Key",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (value) => qrController.text = value,
                        ),
                        const SizedBox(height: 24),
                        customFields(
                          controller: ipController,
                          title: "IP Address",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (value) => ipController.text = value,
                        ),
                        const SizedBox(height: 24),
                        customElevatedButton(
                            title: "Set",
                            onPressed: () {
                              // if (qrController1.text.isEmpty ||
                              //     qrController2.text.isEmpty ||
                              //     qrController3.text.isEmpty ||
                              //     qrController4.text.isEmpty) {
                              //   setState(() {
                              //     isQrEmpty = true;
                              //   });
                              //   Future.delayed(const Duration(seconds: 3), () {
                              //     setState(() {
                              //       isQrEmpty = false;
                              //     });
                              //   });
                              //   return;
                              // }

                              if (!initialSetUpKey.currentState!.validate()) {
                                return;
                              }

                              prefs.setString("Ip", ipController.text);
                              String qrKey = "";

                              // String qrKey = qrController1.text +
                              //     qrController2.text +
                              //     qrController3.text +
                              //     qrController4.text;
                              if (qrController.text.isEmpty) {
                                qrKey = "123456789";
                              } else {
                                qrKey = qrController.text;
                              }
                              int count = qrKey.length;
                              while (count < 32) {
                                for (var i = 0; i < qrKey.length; i++) {
                                  if (count < 32) {
                                    qrKey = qrKey + qrKey[i];
                                    count++;
                                  } else {
                                    break;
                                  }
                                }
                              }

                              prefs.setString("QrCode", qrKey);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Splash(),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget customFields({
  required TextEditingController controller,
  required String title,
  required String? Function(String?) validator,
  required Function(String) onChanged,
}) {
  return Row(
    children: [
      SizedBox(
        width: 88,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: ColorConstant.primaryColor,
          ),
        ),
      ),
      const SizedBox(
        height: 8,
        width: 8,
      ),
      Expanded(
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 110, 108, 108),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
