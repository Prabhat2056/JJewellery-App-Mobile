import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jjewellery/data/query/get_jewellery_rates.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../env_config.dart';
import '../../../utils/color_constant.dart';
import '../../../models/rates.dart';
import '../../../main_common.dart';

class JewelleryRate extends StatefulWidget {
  const JewelleryRate({
    super.key,
    required this.onRefresh,
    required this.data,
    required this.isRefreshing,
  });
  final VoidCallback onRefresh;
  final Rates data;
  final bool isRefreshing;

  @override
  State<JewelleryRate> createState() => _JewelleryRateState();
}

class _JewelleryRateState extends State<JewelleryRate> {
  final GlobalKey ssContainerKey = GlobalKey();
  bool onSharePressed = false;
  List<Map<String, dynamic>> _karatSettings = [];

  late List shopInfo;
  double _getAdditionalRate(String key) {
    return prefs.containsKey(key) ? double.parse(prefs.get(key).toString()) : 0;
  }

  Future loadDataFromDb() async {
    shopInfo = await db.rawQuery('SELECT * FROM ShopInfo');
    if (shopInfo.isNotEmpty && mounted && shopInfo[0]["logo"] != null) {
      precacheImage(
        FileImage(File(shopInfo[0]["logo"].toString())),
        context,
      );
    }
  }

  Future getKaratSettings() async {
    _karatSettings = await db.rawQuery("SELECT * FROM KaratSettings");
  }

  findKaratPercentage(int karat) {
    if (_karatSettings.isEmpty) {
      return (karat / 24) * 100;
    } else {
      return _karatSettings.firstWhere(
          (k) => k["karat"].contains(karat.toString()))["percentage"];
    }
  }

  Future<void> _captureAndShare() async {
    await loadDataFromDb();
    setState(() {
      onSharePressed = true;
    });

    RenderRepaintBoundary boundary = ssContainerKey.currentContext
        ?.findRenderObject() as RenderRepaintBoundary;

    await Future.delayed(const Duration(milliseconds: 80));

    var image = await boundary.toImage(pixelRatio: 3);
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/ss.png').create();
    await imagePath.writeAsBytes(pngBytes!);

    await Share.shareXFiles([XFile(imagePath.path)]);

    setState(() {
      onSharePressed = false;
    });
  }

  bool isToday() {
    var todaysDate = DateTime.now().toString().split(" ")[0];
    var engDate = GetJewelleryRates.rates.englishDate.split(" ")[0];
    if (engDate == todaysDate) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    loadDataFromDb();
    getKaratSettings();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        AssetImage("assets/images/ktmSang.png"),
        context,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getKaratSettings();
  }

  @override
  Widget build(BuildContext context) {
    final goldRate =
        double.parse(widget.data.gold) + _getAdditionalRate("GoldSettings");
    final silverRate =
        double.parse(widget.data.silver) + _getAdditionalRate("SilverSettings");
    final env = EnvConfig.env;

    return Column(
      children: [
        Container(
          padding: onSharePressed ? EdgeInsets.all(16) : EdgeInsets.all(0),
          constraints: onSharePressed ? BoxConstraints(maxWidth: 410) : null,
          child: RepaintBoundary(
            key: ssContainerKey,
            child: Container(
              decoration: BoxDecoration(
                color: ColorConstant.primaryColor,
                border: onSharePressed
                    ? Border.symmetric(
                        horizontal: BorderSide(
                          width: 4,
                          color: ColorConstant.primaryColor,
                        ),
                      )
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: onSharePressed
                      ? Colors.white
                      : ColorConstant.scaffoldColor,
                  borderRadius: onSharePressed
                      ? BorderRadius.circular(60)
                      : BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    env == "prod_sang"
                        ? _buildHeaderSangTitle(onSharePressed: onSharePressed)
                        : _buildHeaderNormalTitle(
                            onSharePressed: onSharePressed),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetalRateColumn(
                          title: "सुन",
                          imageUrl: "assets/images/gold_img.png",
                          rate: goldRate,
                          isIncrease:
                              widget.data.goldDiff.contains("-") ? false : true,
                          changeAmount:
                              widget.data.goldDiff.replaceAll("-", ""),
                          color: ColorConstant.goldColor,
                          onSharePressed: onSharePressed,
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 48,
                                width: 48,
                                child: Image.asset(
                                  "assets/images/playstore.png",
                                ),
                              ),
                              _headerText(
                                "J-Jewellery Software",
                                8,
                                isBold: true,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              onSharePressed
                                  ? Container(
                                      width: 1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.13,
                                      color: ColorConstant.primaryColor,
                                    )
                                  : Container(
                                      width: 1.8,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      color: ColorConstant.primaryColor,
                                    ),
                            ],
                          ),
                        ),
                        _buildMetalRateColumn(
                          title: "चाँदी",
                          imageUrl: "assets/images/silver_img.png",
                          rate: silverRate,
                          isIncrease: widget.data.silverDiff.contains("-")
                              ? false
                              : true,
                          changeAmount:
                              widget.data.silverDiff.replaceAll("-", ""),
                          color: ColorConstant.silverColor,
                          onSharePressed: onSharePressed,
                        ),
                      ],
                    ),
                    Divider(
                      color: ColorConstant.primaryColor,
                      thickness: onSharePressed ? 1 : 1.5,
                    ),
                    onSharePressed
                        ? const SizedBox.shrink()
                        : _buildGoldRateDetails(goldRate: goldRate),
                    onSharePressed && shopInfo.isNotEmpty
                        ? Column(
                            children: [
                              _aboutSection(
                                  img: shopInfo[0]['logo'],
                                  name: shopInfo[0]['short_name'],
                                  contact: shopInfo[0]['contact'],
                                  location: shopInfo[0]['address'])
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSangTitle({required bool onSharePressed}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/images/ktmSang.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 2),
            Column(
              children: [
                SizedBox(
                  height: 32,
                  child: _headerText(
                    "sf7df]8f}= ;'grf=bL Aoj;foL ;=3",
                    onSharePressed ? 27 : 31,
                    isBold: true,
                    fontFam: 'Newa',
                    color: Color(0xFF79502F),
                  ),
                ),
                _headerText(
                  "KATHMANDU GOLD AND SILVER DEALERS' ASSOCIATION",
                  onSharePressed ? 7 : 9,
                  isBold: true,
                  color: Color(0xFF2596BE),
                ),
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 28,
                  child: _headerText(
                    "सुन चाँदीको भाउ",
                    onSharePressed ? 18 : 20,
                    isBold: true,
                    color: ColorConstant.primaryColor,
                  ),
                ),
                _headerText(
                  widget.data.nepaliDate,
                  onSharePressed ? 14 : 16,
                  isBold: true,
                  color: isToday()
                      ? ColorConstant.primaryColor
                      : ColorConstant.errorColor,
                ),
                const SizedBox(height: 2),
                _headerText("Price(Per Tola)", onSharePressed ? 10 : 12,
                    isBold: true, color: ColorConstant.primaryColor),
              ],
            ),
            onSharePressed
                ? const SizedBox(
                    width: 60,
                  )
                : Column(
                    children: [
                      !widget.isRefreshing
                          ? SizedBox(
                              height: 24,
                              child: IconButton(
                                onPressed: widget.onRefresh,
                                icon: Icon(
                                  Icons.refresh,
                                  color: ColorConstant.primaryColor,
                                ),
                                padding: const EdgeInsets.all(0),
                              ),
                            )
                          : SizedBox(
                              height: 16,
                              width: 16,
                              child: const CircularProgressIndicator(),
                            ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 20,
                        child: IconButton(
                          onPressed: _captureAndShare,
                          icon: Icon(Icons.share_sharp,
                              color: ColorConstant.primaryColor),
                          padding: const EdgeInsets.all(0),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderNormalTitle({required bool onSharePressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 60,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            onSharePressed
                ? const SizedBox.shrink()
                : _headerText(
                    isToday() ? "आजको" : "हिजोको",
                    18,
                    color: isToday()
                        ? ColorConstant.primaryColor
                        : ColorConstant.errorColor,
                  ),
            _headerText("सुन चाँदीको भाउ", onSharePressed ? 18 : 20,
                isBold: true, color: ColorConstant.primaryColor),
            _headerText(widget.data.nepaliDate, onSharePressed ? 14 : 16,
                isBold: true,
                color: isToday()
                    ? ColorConstant.primaryColor
                    : ColorConstant.errorColor),
            const SizedBox(height: 2),
            _headerText("Price(Per Tola)", onSharePressed ? 8 : 10,
                isBold: true, color: ColorConstant.primaryColor),
          ],
        ),
        onSharePressed
            ? const SizedBox(
                width: 60,
              )
            : Column(
                children: [
                  SizedBox(
                    height: 48, // Fixed height container
                    child: Center(
                      child: !widget.isRefreshing
                          ? IconButton(
                              onPressed: widget.onRefresh,
                              icon: Icon(Icons.refresh,
                                  color: ColorConstant.primaryColor),
                            )
                          : SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                              ),
                            ),
                    ),
                  ),
                  IconButton(
                    onPressed: _captureAndShare,
                    icon: Icon(Icons.share_sharp,
                        color: ColorConstant.primaryColor),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildGoldRateDetails({required double goldRate}) {
    return Column(
      children: [
        const SizedBox(height: 2),
        _buildRateRow(
          "22K",
          (goldRate * findKaratPercentage(22) * 0.01),
          "18K",
          (goldRate * findKaratPercentage(18) * 0.01),
        ),
        const SizedBox(height: 6),
        _buildRateRow(
          "14K",
          (goldRate * findKaratPercentage(14) * 0.01),
          "12K",
          (goldRate * findKaratPercentage(12) * 0.01),
        ),
      ],
    );
  }

  Widget _buildRateRow(
      String label1, double rate1, String label2, double rate2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRateText(label1, rate1),
        const SizedBox(width: 4),
        _buildRateText(label2, rate2),
      ],
    );
  }

  Widget _buildRateText(String label, double rate) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          width: screenWidth < 410 ? screenWidth * 0.08 : screenWidth * 0.04,
          child: _headerText(label, onSharePressed ? 12 : 14, isBold: true),
        ),
        const SizedBox(width: 4),
        Container(
            width: MediaQuery.of(context).size.width * 0.28,
            constraints: onSharePressed ? BoxConstraints(maxWidth: 80) : null,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: ColorConstant.primaryColor),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: _headerText(
                " ${rate.toStringAsFixed(2)}",
                onSharePressed ? 12 : 14,
                isBold: true,
              ),
            )),
      ],
    );
  }

  Widget _buildMetalRateColumn({
    required String title,
    required String imageUrl,
    required double rate,
    required bool isIncrease,
    required String changeAmount,
    required Color color,
    required bool onSharePressed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _headerText(title, onSharePressed ? 16 : 20,
            color: color, isBold: true),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imageUrl,
            height: onSharePressed ? 90 : 100,
            width: onSharePressed ? 90 : 100,
            fit: BoxFit.contain,
          ),
        ),
        _headerText(
          rate.toInt().toString(),
          onSharePressed ? 17 : 19,
          color: color,
          isBold: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isIncrease ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: isIncrease ? Colors.green : Colors.red,
              size: onSharePressed ? 20 : 22,
            ),
            _headerText(
              "($changeAmount)",
              onSharePressed ? 11 : 13,
              color: isIncrease ? Colors.green : Colors.red,
              isBold: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerText(String text, double size,
      {Color? color, bool isBold = false, String fontFam = 'Quicksand'}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color ?? ColorConstant.primaryColor,
        fontFamily: fontFam,
      ),
    );
  }

  Widget _aboutSection({
    String? img,
    required String name,
    required String contact,
    required String location,
  }) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: img != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.file(
                    File(img),
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            _headerText(
              name,
              12,
              isBold: true,
            ),
            _headerText(
              location,
              11,
              isBold: true,
            ),
            const SizedBox(height: 2),
            _headerText(
              contact,
              11,
              isBold: true,
            ),
          ],
        )
      ],
    );
  }
}
