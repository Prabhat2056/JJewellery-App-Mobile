import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/QrResult/qr_result_bloc.dart';

class LuxuryCalculationPage extends StatefulWidget {
  const LuxuryCalculationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LuxuryCalculationPageState createState() => _LuxuryCalculationPageState();
}

class _LuxuryCalculationPageState extends State<LuxuryCalculationPage> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Luxury Calculation'),
      ),
      body: BlocBuilder<QrResultBloc, QrResultState>(
        buildWhen: (previous, current) =>
            current is QrResultPriceChangedState ||
            current is QrResultInitialState,
        builder: (context, state) {
          if (state is QrResultPriceChangedState ||
              state is QrResultInitialState) {
            final qrData = (state is QrResultPriceChangedState)
                ? state.qrData
                : (state as QrResultInitialState).qrData;

            // Parse values safely, removing commas as done in bloc's stringToDouble
            double netWeight = double.tryParse(qrData.netWeight) ?? 0.0;
            double jartiGram = double.tryParse(qrData.jarti) ?? 0.0;
            double rate = double.tryParse(qrData.rate) ?? 0.0;
            double jyala = double.tryParse(qrData.jyala) ?? 0.0;

            double stone1Price = double.tryParse(qrData.stone1Price) ?? 0.0;
            double stone2Price = double.tryParse(qrData.stone2Price) ?? 0.0;
            double stone3Price = double.tryParse(qrData.stone3Price) ?? 0.0;

            // Non-Taxable Amount = sum of stone prices
            double nonTaxable = stone1Price + stone2Price + stone3Price;

            // Base Amount calculation matching QrResultBloc.calcPrice() logic
            double baseAmount;
            if (qrData.jarti.trim().isEmpty) {
              baseAmount = (netWeight * (rate / 11.664)) + jyala + nonTaxable;
            } else {
              baseAmount = ((netWeight + jartiGram) * (rate / 11.664)) +
                  jyala +
                  nonTaxable;
            }

            // Taxable Amount = Base Amount - Non-Taxable Amount
            double taxableAmount = baseAmount - nonTaxable;
            if (taxableAmount < 0) taxableAmount = 0;

            // Luxury Tax = 2% of Taxable Amount
            double luxury = taxableAmount * 0.02;

            // Total = Base Amount + Luxury Tax
            double total = baseAmount + luxury;

            // For QR scan, use MRP as total if available
            if (qrData.code.isNotEmpty && qrData.mrp.isNotEmpty) {
              double mrpValue =
                  double.tryParse(qrData.mrp.replaceAll(',', '')) ?? 0.0;
              total = mrpValue;
            }

            Widget buildRow(String title, double value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16)),
                    Text("Rs ${value.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildRow("Base Amount", baseAmount),
                  buildRow("Non-Taxable Amount", nonTaxable),
                  buildRow("Taxable Amount", taxableAmount),
                  const Divider(),
                  buildRow("Luxury Tax (2%)", luxury),
                  const Divider(),
                  buildRow("Total", total),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}


