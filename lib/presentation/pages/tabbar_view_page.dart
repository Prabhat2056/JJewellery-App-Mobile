import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jjewellery/bloc/QrResult/qr_result_bloc.dart';

import 'package:jjewellery/data/query/get_jewellery_rates.dart';
import 'package:jjewellery/helper/helper_functions.dart';
import 'package:jjewellery/models/qr_data_model.dart';

import 'package:jjewellery/models/rates.dart';
import 'package:jjewellery/presentation/pages/bill_page.dart';

import 'package:jjewellery/presentation/pages/graph_page.dart';
import 'package:jjewellery/presentation/pages/home_page.dart';

import 'package:jjewellery/presentation/pages/qr_result.dart';

import 'package:jjewellery/presentation/pages/qr_scanner.dart';
import 'package:jjewellery/presentation/widgets/Global/appbar.dart';

import 'package:jjewellery/presentation/widgets/Global/tabbar_bottom_navigation.dart';

import 'package:permission_handler/permission_handler.dart';

class TabbarViewPage extends StatefulWidget {
  const TabbarViewPage({
    super.key,
    required this.isScanned,
  });
  final bool isScanned;

  @override
  State<TabbarViewPage> createState() => _TabbarViewPageState();
}

class _TabbarViewPageState extends State<TabbarViewPage>
    with SingleTickerProviderStateMixin {
  final dio = Dio();
  GetJewelleryRates jewelleryRates = GetJewelleryRates();

  StreamController<Rates> jewelleryRateStreamController =
      StreamController<Rates>.broadcast();

  late TabController tabController;

  Future<void> requestNotificationPermission(BuildContext context) async {
    var status = await Permission.notification.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      var result = await Permission.notification.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        if (context.mounted) {
          _showPermissionDialog(context);
        }
      }
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black54,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Allow JJewellery to show notifications?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text(
                    "Allow",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    openAppSettings(); // Open settings for user to enable notifications manually
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 5,
      vsync: this,
    );
    requestNotificationPermission(context);
    if (widget.isScanned) {
      tabController.index = 2;
    }
    setState(() {});
    tabController.addListener(() {
      if (tabController.index == 2 ) {
        onQrPressed(context);
        tabController.index = tabController.previousIndex;
        return;
      }
      if (tabController.index == 3) {
        Future.microtask(() {
          if (mounted) {
            BlocProvider.of<QrResultBloc>(context).add(QrResultInitialEvent(
              isUpdate: false,
              qrData: QrDataModel(
                id: "",
                code: "",
                item: "",
                itemId: 0,
                materialId: 0,
                pcs: 0,
                metal: "",
                grossWeight: "",
                netWeight: "0",
                purity: "",
                jarti: "0",
                jartiPercentage: "0",
                jartiLal: "",
                jyala: "0",
                //jartiAmount: '0',
                jyalaPercentage: "0",
                mrp: "",
                price: "",
                todayRate: "",
                rate: "0",
                stone1Name: "",
                stone1Id: 0,
                stone1Weight: "",
                stone1Price: "",
                stone2Name: "",
                stone2Id: 0,
                stone2Weight: "",
                stone2Price: "",
                stone3Name: "",
                stone3Id: 0,
                stone3Weight: "",
                stone3Price: "",
                // Calculated fields set to 0; will be computed later
                baseAmount: 0,
                nonTaxableAmount: 0,
                taxableAmount: 0,
                luxuryAmount: 0,
                total: 0,
                expectedAmount: "",
                expectedAmountDiscount: "",
                discount: "",

                 jartiAmount: "",
                // netWeightAmount: "",
                // stoneTotalPrice: "",

                newJyala: "0", //
                newJyalaPercentage: "0", //
                newJarti: "0", //
                newJartiPercentage: "0", //
                newJartiLal: "0", //
                newJartiAmount: "0",
                newStone1Price: "0",
                newStone2Price: "0",
                newStone3Price: "0",
                newStoneTotalPrice: "0",

              ),
            ));
          }
        });
        return;
      }
      if (tabController.index == 4) {
        tabController.index = 0;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const BillPage(),
        ));
        return;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getJewelleryRates();
  }

  void getJewelleryRates() async {
    jewelleryRateStreamController.sink
        .add(await jewelleryRates.requestRatesFromServer());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MyAppbar(
          isHomeWidget: true,
        ),
        body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              HomePage(
                  jewelleryRateStreamController: jewelleryRateStreamController,
                  jewelleryRates: jewelleryRates),
              GraphPage(),
              widget.isScanned ? QrResult() : QrScanner(),
              QrResult(),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ]),
        bottomNavigationBar:
            TabbarBottomNavigation(tabController: tabController),
      ),
    );
  }
}
