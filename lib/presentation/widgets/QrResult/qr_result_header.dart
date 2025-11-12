import 'package:flutter/material.dart';
import 'package:jjewellery/data/query/get_jewellery_rates.dart';
import 'package:jjewellery/presentation/widgets/QrResult/row_with_textfield.dart';

Widget qrResultHeader({
  required bool showCalculation,
  required String item,
  required String code,
  required String mrp,
  required String todayRate,
  required String metal,
  required String purity,
  required double width,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showCalculation
                ? buildDetailRow(
                    label: "Date",
                    value: GetJewelleryRates.rates.nepaliDate,
                    textSize: 14)
                : buildDetailRow(
                    label: "Item",
                    value: item,
                    textSize: 16,
                  ),
            width > 410
                ? const SizedBox.shrink()
                : buildDetailRow(
                    label: "Code",
                    value: code,
                    textSize: showCalculation ? 14 : 16,
                  ),
            showCalculation
                ? buildDetailRow(
                    label: "Mrp",
                    value: mrp,
                    textSize: 14,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      const Spacer(),
      width > 410
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDetailRow(
                    label: "Code",
                    value: code,
                    textSize: showCalculation ? 14 : 16,
                  ),
                  showCalculation
                      ? buildDetailRow(
                          label: "Metal",
                          value: metal,
                          textSize: showCalculation ? 14 : 16,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            )
          : const SizedBox.shrink(),
      const Spacer(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showCalculation
                ? buildDetailRow(
                    label: "Rate",
                    value: todayRate,
                    textSize: 14,
                  )
                : const SizedBox.shrink(),
            width > 410
                ? const SizedBox.shrink()
                : buildDetailRow(
                    label: "Metal",
                    value: metal,
                    textSize: showCalculation ? 14 : 16,
                  ),
            buildDetailRow(
              label: "Purity",
              value: purity.contains("k") || purity.contains("K")
                  ? purity
                  : "${purity}K",
              textSize: showCalculation ? 14 : 16,
            ),
          ],
        ),
      ),
    ],
  );
}
