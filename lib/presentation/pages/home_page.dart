import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/query/get_jewellery_rates.dart';
import '../../helper/helper_functions.dart';
import '../../utils/color_constant.dart';
import '../widgets/Global/custom_toast.dart';
import '../widgets/home/jewellery_rate.dart';
import '../widgets/home/unit_converter.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      required this.jewelleryRateStreamController,
      required this.jewelleryRates});
  final StreamController jewelleryRateStreamController;
  final GetJewelleryRates jewelleryRates;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRefreshing = false;

  void getJewelleryRates() async {
    setState(() {
      isRefreshing = true;
    });
    var getRates = await widget.jewelleryRates.requestRatesFromServer();
    setState(() {
      isRefreshing = false;
    });

    widget.jewelleryRateStreamController.sink.add(getRates);
  }

  loadData() async {
    setState(() {
      isRefreshing = true;
    });
    await widget.jewelleryRates.requestRatesFromServer();
    setState(() {
      isRefreshing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const UnitConverter(),
            StreamBuilder(
              stream: widget.jewelleryRateStreamController.stream,
              builder: (context, state) => JewelleryRate(
                data: GetJewelleryRates.rates,
                isRefreshing: isRefreshing,
                onRefresh: () async {
                  bool connectivityResult = await checkInternetConnection();
                  if (connectivityResult) {
                    setState(() {
                      isRefreshing = true;
                    });

                    // Pass forceRefresh: true to force a new API call
                    var newRates = await widget.jewelleryRates
                        .requestRatesFromServer(forceRefresh: true);

                    // Update the stream with new data
                    widget.jewelleryRateStreamController.sink.add(newRates);

                    setState(() {
                      isRefreshing = false;
                    });
                  } else {
                    customToast("No Internet Connection", ColorConstant.errorColor);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
