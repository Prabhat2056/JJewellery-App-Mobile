


import 'package:flutter/material.dart';
import 'package:jjewellery/models/qr_data_model.dart';

class DiscountSummaryWidget extends StatefulWidget {
  const DiscountSummaryWidget({
    super.key,
    required this.originalQrData,
    required this.qrData,
  });

  final QrDataModel originalQrData;
  final QrDataModel qrData;

  @override
  State<DiscountSummaryWidget> createState() => _DiscountSummaryWidgetState();
}

class _DiscountSummaryWidgetState extends State<DiscountSummaryWidget> {
  bool isExpanded = false;

  // ✅ Converts string to double safely
  double stringToDouble(String value) {
    String sanitized = value.replaceAll(',', '').trim();
    return double.tryParse(sanitized) ?? 0.0;
  }

  double _calculateJartiAmount(String jarti, String rate) {
  if (jarti.isEmpty || jarti == "0") return 0.0;
  double jartiValue = double.tryParse(jarti.replaceAll('K', '')) ?? 0.0;
  double rateValue = double.tryParse(rate.replaceAll(',', '')) ?? 0.0;
  return jartiValue * (rateValue / 11.664);
}

// double _calculatestonePrice(String stonePrice) {

// }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.3;

    double originalJartiAmount = _calculateJartiAmount(
    widget.originalQrData.jarti, 
    widget.originalQrData.rate
  );
  
  double currentJartiAmount = _calculateJartiAmount(
    widget.qrData.jarti, 
    widget.qrData.rate
  );

    // Calculate item discount
    double originalPrice = stringToDouble(widget.originalQrData.price);
    double discountedPrice = stringToDouble(widget.qrData.price);
    double itemDiscount = originalPrice - discountedPrice;

    // Extra discount entered via ExpectedAmount
    double expectedDiscount = stringToDouble(widget.qrData.expectedAmountDiscount);//

    // Total discount
    double totalDiscount = itemDiscount + expectedDiscount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ----------------------------------------------------
        //  Summary row (total difference)
        // ----------------------------------------------------
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
                "Rs. ${totalDiscount.toStringAsFixed(2)}",
                style: const TextStyle(
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
              ),
            ],
          ),
        ),

        // ----------------------------------------------------
        //  Expanded details
        // ----------------------------------------------------
        if (isExpanded)
          Column(
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
              const Divider(),
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
                t1: "Jarti(gm)",
                t2: widget.originalQrData.jarti,
                t3: widget.qrData.jarti,
                width: width,
              ),
               _buildDiscountRow(
                t1: "       (Rs.)",
                t2: "${originalJartiAmount.toStringAsFixed(2)}",
                t3: "${currentJartiAmount.toStringAsFixed(2)}",
                // t2: originalJartiAmount.toStringAsFixed(2),
                // t3: currentJartiAmount.toStringAsFixed(2),
                width: width,
              ),
              
              _buildDiscountRow(
                t1: "Jyala",
                t2: widget.originalQrData.jyala,
                //t3: widget.qrData.jyala,
                t3: (widget.qrData.newJyala.isNotEmpty && widget.qrData.newJyala != "0.000")
                  ? widget.qrData.newJyala  // Show newJyala if calculated
                  : widget.qrData.jyala,   
                width: width,
              ),
              _buildDiscountRow(
                t1: "Stone 1",
                t2: widget.originalQrData.stone1Price,
                //t3: widget.qrData.stone1Price,
                t3: (widget.qrData.newStone1Price.isNotEmpty && widget.qrData.newStone1Price != "0.00")
                  ? widget.qrData.newStone1Price  // Show newStone1Price if calculated
                  : widget.qrData.stone1Price,
                
                width: width,
              ),
              _buildDiscountRow(
                t1: "Stone 2",
                t2: widget.originalQrData.stone2Price,
                //t3: widget.qrData.stone2Price,
                t3: (widget.qrData.newStone2Price.isNotEmpty && widget.qrData.newStone2Price != "0.00")
                  ? widget.qrData.newStone2Price  // Show newStone2Price if calculated
                  : widget.qrData.stone2Price,
                width: width,
              ),
              _buildDiscountRow(
                t1: "Stone 3",
                t2: widget.originalQrData.stone3Price,
                //t3: widget.qrData.stone3Price,
                
                t3: (widget.qrData.newStone3Price.isNotEmpty && widget.qrData.newStone3Price != "0.00")
                  ? widget.qrData.newStone3Price  // Show newStone3Price if calculated
                  : widget.qrData.stone3Price,
                width: width,
              ),
              const Divider(color: Color.fromARGB(255, 156, 69, 62)),
              _buildDiscountRow(
                t1: "Luxury Tax",
                t2: widget.originalQrData.luxuryAmount.toStringAsFixed(2),
                t3: widget.qrData.luxuryAmount.toStringAsFixed(2),
                width: width,
              ),
              const Divider(color: Color.fromARGB(255, 156, 69, 62)),
              _buildDiscountRow(
                t1: "Total",
                t2: widget.originalQrData.total.toStringAsFixed(2),
                t3: widget.qrData.total.toStringAsFixed(2),
                width: width,
                isTitle: true,
              ),

              const SizedBox(height: 12),

              
            ],
          ),
      ],
    );
  }

  Widget _buildDiscountRow({
    required String t1,
    required String t2,
    required String t3,
    required double width,
    bool isTitle = false,
  }) {
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

