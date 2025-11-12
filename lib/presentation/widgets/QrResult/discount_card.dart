import 'package:flutter/material.dart';
import 'package:jjewellery/models/qr_data_model.dart';

class DiscountCard extends StatefulWidget {
  const DiscountCard({
    super.key,
    required this.qrData,
    required this.originalQrData,
  });
  final QrDataModel qrData;
  final QrDataModel originalQrData;

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  bool isExpanded = false;

  double stringToDouble(String value) {
    String sanitizedValue = value.replaceAll(',', '').trim();
    return double.tryParse(sanitizedValue) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.3;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rs. ${(stringToDouble(widget.originalQrData.price) - stringToDouble(widget.qrData.price)).toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Icon(
                isExpanded
                    ? Icons.arrow_circle_up_rounded
                    : Icons.arrow_circle_down_rounded,
                color: Colors.grey,
              )
            ],
          ),
        ),
        !isExpanded
            ? const SizedBox()
            : Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 2),
                  _buildDiscountRow(
                    t1: "Title",
                    t2: "Actual",
                    t3: "Discounted",
                    width: width,
                    isTitle: true,
                  ),
                  const SizedBox(height: 2),
                  Divider(),
                  _buildDiscountRow(
                    t1: "Rate",
                    t2: widget.originalQrData.rate,
                    t3: widget.qrData.rate,
                    width: width,
                  ),
                  _buildDiscountRow(
                    t1: "Net Wt.",
                    t2: widget.originalQrData.netWeight,
                    t3: widget.qrData.netWeight,
                    width: width,
                  ),
                  _buildDiscountRow(
                    t1: "Jarti",
                    t2: widget.originalQrData.jarti,
                    t3: widget.qrData.jarti,
                    width: width,
                  ),
                  _buildDiscountRow(
                    t1: "Jyala",
                    t2: widget.originalQrData.jyala,
                    t3: widget.qrData.jyala,
                    width: width,
                  ),
                  _buildDiscountRow(
                    t1: "Stone 1",
                    t2: widget.originalQrData.stone1Price,
                    t3: widget.qrData.stone1Price,
                    width: width,
                  ),
                  _buildDiscountRow(
                    t1: "Stone 2",
                    t2: widget.originalQrData.stone2Price,
                    t3: widget.qrData.stone2Price,
                    width: width,
                  ),
                  _buildDiscountRow(
                    t1: "Stone 3",
                    t2: widget.originalQrData.stone3Price,
                    t3: widget.qrData.stone3Price,
                    width: width,
                  ),
                  Divider(),
                  _buildDiscountRow(
                      t1: "Total",
                      t2: widget.originalQrData.price,
                      t3: widget.qrData.price,
                      width: width,
                      isTitle: true),
                ],
              )
      ],
    );
  }

  Widget _buildDiscountRow(
      {required String t1,
      required String t2,
      required String t3,
      required double width,
      bool isTitle = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width,
          child: Text(
            t1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: Text(
            t2,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: Text(
            t3,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
