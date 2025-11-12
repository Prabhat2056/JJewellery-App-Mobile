import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/query/get_jewellery_rates.dart';
import '../../../main_common.dart';
import '../../../utils/color_constant.dart';

class KaratPriceHeader extends StatefulWidget {
  const KaratPriceHeader({
    super.key,
    required this.onKaratPricePressed,
  });

  final Function(String rate) onKaratPricePressed;

  @override
  State<KaratPriceHeader> createState() => _KaratPriceHeaderState();
}

class _KaratPriceHeaderState extends State<KaratPriceHeader> {
  late List karatSettings;
  late StreamController controller = StreamController();

  Future<void> initializeSettings() async {
    karatSettings = await db.rawQuery("SELECT * FROM KaratSettings");
    controller.sink.add(karatSettings);
  }

  @override
  void initState() {
    super.initState();
    initializeSettings();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 60,
            child: GridView.builder(
              itemCount: karatSettings.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.5,
              ),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final rate = (double.parse(GetJewelleryRates.rates.gold) *
                        (karatSettings[index]["percentage"] / 100))
                    .toStringAsFixed(2);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: () => widget.onKaratPricePressed(rate),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(132, 255, 255, 255),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            karatSettings[index]['karat'],
                            style: TextStyle(
                              color: ColorConstant.goldColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            rate,
                            style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
