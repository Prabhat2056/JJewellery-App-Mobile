import 'dart:async';
import 'package:flutter/material.dart';

import 'package:jjewellery/data/query/get_payment_modes.dart';
import 'package:jjewellery/presentation/pages/tabbar_view_page.dart';
import 'package:jjewellery/presentation/widgets/SettingsPage/shop_info_settings.dart';
import 'package:jjewellery/utils/color_constant.dart';

import '../../data/query/get_items.dart';
import '../../data/query/get_jewellery_rates.dart';

import '../../main_common.dart';
import '../../models/rates.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  GetJewelleryRates jewelleryRates = GetJewelleryRates();
  GetPaymentModes getPaymentModes = GetPaymentModes();

  void getPrefs() async {
    var rates = await db.rawQuery("SELECT * FROM RATES");

    if (rates.isNotEmpty) {
      GetJewelleryRates.rates = Rates(
          serverId: rates[0]['serverId'].toString(),
          nepaliDate: rates[0]['nep_date'].toString(),
          gold: rates[0]['gold'].toString(),
          silver: rates[0]['silver'].toString(),
          englishDate: rates[0]['eng_date'].toString(),
          goldDiff: rates[0]['gold_diff'].toString(),
          silverDiff: rates[0]['silver_diff'].toString());
    }

    if (rates.isEmpty) {
      prefs.setBool("isfirstLogin", true);
    }
    // await jewelleryRates.requestRatesFromServer();
  }

  @override
  void initState() {
    super.initState();
    getPrefs();

    //to fetch data for payment mode....this avoids multiple fetch in each qr scan
    if (prefs.getString("Ip") != null) {
      // BlocProvider.of<JewelleryOrderBloc>(context).add(PaymentModeLoadEvent());
      // BlocProvider.of<JewelleryOrderBloc>(context).add(ItemMaterialsLoadEvent());
      ItemsMaterialsDataRepository().initialize();
    }

    prefs.containsKey("isfirstLogin") == false
        ? Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CompanyInfo(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            ),
          )
        : Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TabbarViewPage(
                  isScanned: false,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: ColorConstant.scaffoldColor),
          child: Center(
            child: Image.asset(
              'assets/images/playstore.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
