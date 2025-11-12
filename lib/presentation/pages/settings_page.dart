import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/Settings/settings_bloc.dart';
import 'package:jjewellery/endpoints.dart';
import 'package:jjewellery/helper/helper_functions.dart';
import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';
import 'package:jjewellery/presentation/widgets/SettingsPage/privacy_terms_page.dart';

import '../widgets/SettingsPage/shop_info_settings.dart';
import '../widgets/SettingsPage/karat_settings_page.dart';
import '../../utils/color_constant.dart';
import '../../main_common.dart';
import '../widgets/Global/appbar.dart';
import '../widgets/SettingsPage/listt_tile_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController ipController = TextEditingController(
      // text: prefs.getString("Ip") ?? ""
      );
  TextEditingController qrController = TextEditingController();
  TextEditingController goldRateController =
      TextEditingController(text: prefs.getString("GoldSettings") ?? "0.00");
  TextEditingController silverRateController =
      TextEditingController(text: prefs.getString("SilverSettings") ?? "0.00");

  final qrFormKey = GlobalKey<FormState>();
  final ipFormKey = GlobalKey<FormState>();

  bool isLoggedIn = true;
  bool isResponse = true;

  @override
  void initState() {
    super.initState();
    if (prefs.getBool("ShowCalculation") == null) {
      prefs.setBool("ShowCalculation", true);
    }
  }

  void onShowCalcChanged() {
    setState(() {
      prefs.setBool("ShowCalculation", !prefs.getBool("ShowCalculation")!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppbar(
          isHomeWidget: false,
          title: "Settings",
        ),
        body: isResponse
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: ListView(
                  children: [
                    customListTile(
                      title: "Shop",
                      icon: Icons.business_outlined,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CompanyInfo(),
                          ),
                        );
                      },
                    ),
                    customListTile(
                      title: "Rates",
                      icon: Icons.currency_rupee_outlined,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => customSettingBox(
                            context: context,
                            title: "Rates Settings",
                            onPressed: () {
                              setState(() {
                                prefs.setString(
                                    "GoldSettings",
                                    goldRateController.text.isEmpty
                                        ? "0"
                                        : goldRateController.text);
                                prefs.setString(
                                    "SilverSettings",
                                    silverRateController.text.isEmpty
                                        ? "0"
                                        : silverRateController.text);
                              });
                              BlocProvider.of<SettingsBloc>(context)
                                  .add(OnRatesSettingChangedEvent());

                              Navigator.pop(context);
                            },
                            twoTextFields: true,
                            label1: "Gold",
                            label2: "Silver",
                            label1Controller: goldRateController,
                            label2Controller: silverRateController,
                          ),
                        );
                      },
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Gold    : ${prefs.getString("GoldSettings") ?? "0"} ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Silver  : ${prefs.getString("SilverSettings") ?? "0"} ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    isLoggedIn
                        ? Column(
                            children: [
                              customListTile(
                                title: "Ip Address",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => customSettingBox(
                                      context: context,
                                      controller: ipController,
                                      key: ipFormKey,
                                      title: "Ip Address Settings",
                                      warnings:
                                          "**App must be restarted on IP change**",
                                      onPressed: () {
                                        if (!ipFormKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        prefs.setString(
                                            "Ip", ipController.text);
                                        SystemNavigator.pop();
                                      },
                                    ),
                                  );
                                },
                                icon: Icons.network_check_outlined,
                                // trailing: Text(
                                //   prefs.getString("Ip") ?? "",
                                //   style: const TextStyle(
                                //       fontWeight: FontWeight.bold),
                                // ),
                              ),
                              customListTile(
                                title: "Qr Key ",
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => customSettingBox(
                                          context: context,
                                          key: qrFormKey,
                                          controller: qrController,
                                          title: "Qr Key Settings",
                                          onChanged: (value) =>
                                              qrController.text = value,
                                          onPressed: () {
                                            if (!qrFormKey.currentState!
                                                .validate()) {
                                              return;
                                            }
                                            int count =
                                                qrController.text.length;
                                            String qrKey = qrController.text;
                                            while (count < 32) {
                                              for (var i = 0;
                                                  i < qrKey.length;
                                                  i++) {
                                                if (count < 32) {
                                                  qrKey = qrKey + qrKey[i];
                                                  count++;
                                                } else {
                                                  break;
                                                }
                                              }
                                            }
                                            prefs.setString("QrCode", qrKey);
                                            Navigator.pop(context);
                                          }));
                                },
                                icon: Icons.key_outlined,
                                // trailing: Text(
                                //   "****",
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //     color: ColorConstant.primaryColor,
                                //     fontSize: 20,
                                //   ),
                                // ),
                              ),
                              customListTile(
                                title: "Karat",
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          KaratSettingsPage()),
                                ),
                                icon: Icons.monetization_on_outlined,
                              ),
                              customListTile(
                                title: "Show Calculation",
                                icon: Icons.calculate_outlined,
                                onTap: onShowCalcChanged,
                                trailing: Transform.scale(
                                  scaleX: 0.8,
                                  scaleY: 0.8,
                                  child: Switch(
                                    inactiveThumbColor:
                                        ColorConstant.primaryColor,
                                    inactiveTrackColor:
                                        ColorConstant.scaffoldColor,
                                    onChanged: (value) {
                                      setState(() {
                                        prefs.setBool("ShowCalculation", value);
                                      });
                                    },
                                    value: prefs.getBool("ShowCalculation") ??
                                        false,
                                  ),
                                ),
                              ),
                              customListTile(
                                title: "Log out",
                                icon: Icons.logout_outlined,
                                onTap: () async {
                                  if (!prefs.containsKey("accessToken")) {
                                    customToast("You have not logged in yet",
                                        ColorConstant.errorColor);
                                    return;
                                  }
                                  var accessToken =
                                      prefs.getString("accessToken");
                                  if (accessToken == "" ||
                                      accessToken == null) {
                                    customToast("You have not logged in yet",
                                        ColorConstant.errorColor);
                                    return;
                                  }
                                  int userId = getUserId(token: accessToken);
                                  setState(() {
                                    isResponse = false;
                                  });
                                  try {
                                    final Response response =
                                        await Dio().delete(
                                      "${Endpoints.baseUrl}Authentication/Logout",
                                      queryParameters: {"UserId": userId},
                                    );
                                   
                                    if (response.statusCode == 200) {
                                      prefs.setString("accessToken", "");
                                      prefs.setString("refreshToken", "");
                                      setState(() {
                                        isResponse = true;
                                      });
                                      customToast("Logged Out Successfully",
                                          ColorConstant.primaryColor);
                                    }
                                  } catch (e) {
                                    customToast("Unable to log out",
                                        ColorConstant.errorColor);
                                  }
                                  setState(() {
                                    isResponse = true;
                                  });
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        bottomSheet: Container(
          decoration: BoxDecoration(color: Colors.white24, boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 2,
              spreadRadius: 2,
              offset: const Offset(2, 5),
            )
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                child: const Text("Privacy Policy"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: ColorConstant.scaffoldColor,
                      content: PrivacyTermsPage(
                        isTermsCondition: false,
                      ),
                    ),
                  );
                },
              ),
              Text(
                "|",
                style: TextStyle(
                  color: ColorConstant.primaryColor,
                ),
              ),
              TextButton(
                child: const Text("Terms & Conditions"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: ColorConstant.scaffoldColor,
                      content: PrivacyTermsPage(
                        isTermsCondition: true,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
