import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/presentation/widgets/QrResult/stone_table_rows.dart';

import '../../../bloc/QrResult/qr_result_bloc.dart';

Widget qrResultStoneTable(
    {required TextEditingController stone1NameController,
    required TextEditingController stone1WeightController,
    required TextEditingController stone1PriceController,
    required TextEditingController stone2NameController,
    required TextEditingController stone2WeightController,
    required TextEditingController stone2PriceController,
    required TextEditingController stone3NameController,
    required TextEditingController stone3WeightController,
    required TextEditingController stone3PriceController,
    required state,
    required context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "Stone Name",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Weight (Crt)",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Price (Rs)",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        // Table Rows
        stoneTableRows(
          nameController: stone1NameController,
          weightController: stone1WeightController,
          priceController: stone1PriceController,
          nameValidator: (value) {
            return value!.isEmpty &&
                    (stone1WeightController.text.isNotEmpty ||
                        stone1PriceController.text.isNotEmpty)
                ? "Enter Name"
                : null;
          },
          weightValidator: (value) {
            return value!.isEmpty &&
                    (stone1NameController.text.isNotEmpty ||
                        stone1PriceController.text.isNotEmpty)
                ? "Enter Weight"
                : null;
          },
          priceValidator: (value) {
            return value!.isEmpty &&
                    (stone1NameController.text.isNotEmpty ||
                        stone1WeightController.text.isNotEmpty)
                ? "Enter Price"
                : null;
          },
          onNameChanged: (value) => state.qrData.stone1Name = value,
          onWeightChanged: (value) => state.qrData.stone1Weight = value,
          onPriceChanged: (value) {
            state.qrData.stone1Price = value;
            BlocProvider.of<QrResultBloc>(context)
                .add(QrResultRateChangedEvent(qrData: state.qrData));
          },
        ),
        const SizedBox(height: 8),
        stoneTableRows(
          nameController: stone2NameController,
          weightController: stone2WeightController,
          priceController: stone2PriceController,
          nameValidator: (value) {
            return value!.isEmpty &&
                    (stone2WeightController.text.isNotEmpty ||
                        stone2PriceController.text.isNotEmpty)
                ? "Enter Name"
                : null;
          },
          weightValidator: (value) {
            return value!.isEmpty &&
                    (stone2NameController.text.isNotEmpty ||
                        stone2PriceController.text.isNotEmpty)
                ? "Enter Weight"
                : null;
          },
          priceValidator: (value) {
            return value!.isEmpty &&
                    (stone2NameController.text.isNotEmpty ||
                        stone2WeightController.text.isNotEmpty)
                ? "Enter Price"
                : null;
          },
          onNameChanged: (value) => state.qrData.stone2Name = value,
          onWeightChanged: (value) => state.qrData.stone2Weight = value,
          onPriceChanged: (value) {
            state.qrData.stone2Price = value;
            BlocProvider.of<QrResultBloc>(context)
                .add(QrResultRateChangedEvent(qrData: state.qrData));
          },
        ),
        const SizedBox(height: 8),
        stoneTableRows(
          nameController: stone3NameController,
          weightController: stone3WeightController,
          priceController: stone3PriceController,
          nameValidator: (value) {
            return value!.isEmpty &&
                    (stone3WeightController.text.isNotEmpty ||
                        stone3PriceController.text.isNotEmpty)
                ? "Enter Name"
                : null;
          },
          weightValidator: (value) {
            return value!.isEmpty &&
                    (stone3NameController.text.isNotEmpty ||
                        stone3PriceController.text.isNotEmpty)
                ? "Enter Weight"
                : null;
          },
          priceValidator: (value) {
            return value!.isEmpty &&
                    (stone3NameController.text.isNotEmpty ||
                        stone3WeightController.text.isNotEmpty)
                ? "Enter Price"
                : null;
          },
          onNameChanged: (value) => state.qrData.stone3Name = value,
          onWeightChanged: (value) => state.qrData.stone3Weight = value,
          onPriceChanged: (value) {
            state.qrData.stone3Price = value;
            BlocProvider.of<QrResultBloc>(context)
                .add(QrResultRateChangedEvent(qrData: state.qrData));
          },
        ),
      ],
    ),
  );
}
