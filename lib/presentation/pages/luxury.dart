





import 'package:flutter/material.dart';
import 'package:jjewellery/models/qr_data_model.dart';

class LuxuryCalculationPage extends StatelessWidget {
  final double baseAmount;
  final double nonTaxableAmount;
  final double taxableAmount;
  final double luxuryAmount;
  final double total;
  final QrDataModel qrData;

  const LuxuryCalculationPage({
    super.key,
    required this.baseAmount,
    required this.nonTaxableAmount,
    required this.taxableAmount,
    required this.luxuryAmount,
    required this.total,
    required this.qrData,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    final valueStyle = const TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow("Base Amount", baseAmount, labelStyle, valueStyle),
          _buildRow("Non-Taxable Amount", nonTaxableAmount, labelStyle, valueStyle),
          _buildRow("Taxable Amount", taxableAmount, labelStyle, valueStyle),
          _buildRow("Luxury Amount (2%)", luxuryAmount, labelStyle, valueStyle),
          const Divider(thickness: 1.2),
          _buildRow(
            "Total",
            total,
            labelStyle.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
            valueStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  

  static Widget _buildRow(String label, double value, TextStyle labelStyle, TextStyle valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text("Rs ${value.toStringAsFixed(2)}", style: valueStyle),
        ],
      ),
    );
  }
}
