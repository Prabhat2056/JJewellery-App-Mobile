import 'package:flutter/material.dart';

import '/presentation/widgets/home/unit_conversion_field.dart';
import '/utils/color_constant.dart';

class UnitConverter extends StatefulWidget {
  const UnitConverter({super.key});

  @override
  State<UnitConverter> createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  TextEditingController tolaController = TextEditingController();
  TextEditingController lalController = TextEditingController();
  TextEditingController gramController = TextEditingController();

  void onGramChange(String value) {
    if (value.isEmpty || value == "0.000") {
      setState(() {
        gramController.clear();
        lalController.clear();
        tolaController.clear();
      });
      return;
    }

    double convertedValue = double.parse(value) / 11.664;
    double tola = convertedValue.floorToDouble();
    double lal = (convertedValue - tola) * 100;

    setState(() {
      tolaController.text = tola.toStringAsFixed(3);
      lalController.text = lal.toStringAsFixed(3);
    });
  }

  void onTolaChange(String value) {
    if (value.isEmpty || value == "0.000") {
      if (lalController.text.isEmpty || lalController.text == "0.000") {
        setState(() {
          gramController.clear();
          lalController.clear();
          tolaController.clear();
        });
        return;
      }
      value = "0.0";
    }
    double tola = double.tryParse(value) ?? 0.0;
    double lal = double.tryParse(lalController.text) ?? 0.0;
    tola += lal * 0.01;
    setState(() {
      gramController.text = (tola * 11.664).toStringAsFixed(3);
    });
  }

  void onLalChange(String value) {
    if (value.isEmpty || value == "0.000") {
      if (tolaController.text.isEmpty || tolaController.text == "0.000") {
        setState(() {
          gramController.clear();
          lalController.clear();
          tolaController.clear();
        });
        return;
      }
      value = "0.0";
    }

    double lal = double.tryParse(value) ?? 0.0;
    double tola = double.tryParse(tolaController.text) ?? 0.0;
    tola += lal * 0.01;

    setState(() {
      gramController.text = (tola * 11.664).toStringAsFixed(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 0,
      ),
      height: 120,
      decoration: BoxDecoration(
        color: ColorConstant.primaryColor,
      ),
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              unitConversionField(
                  title: "Gram",
                  controller: gramController,
                  onChanged: onGramChange),
              Icon(
                Icons.swap_horiz,
                size: 30,
                color: Colors.white,
              ),
              unitConversionField(
                  title: "Tola",
                  controller: tolaController,
                  onChanged: onTolaChange),
              const SizedBox(width: 10),
              unitConversionField(
                title: "Lal",
                controller: lalController,
                onChanged: onLalChange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
