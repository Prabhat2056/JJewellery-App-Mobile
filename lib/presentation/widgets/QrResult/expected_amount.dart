


//-------------------------------------------display discount-----------------------------------------------
import 'package:flutter/material.dart';

class ExpectedAmount extends StatefulWidget {
  final TextEditingController controller;
  final double total;
  final void Function(double)? onDiscountCalculated;
  final void Function(String)? onChanged;

  final void Function(double)? onExpectedAmountEntered;
  //final double jyalaAmt = 0.123; // Example fixed jyala amount

  const ExpectedAmount({
    super.key,
    required this.controller,
    required this.total,
    this.onDiscountCalculated,
    this.onChanged,
    this.onExpectedAmountEntered,
  });

  @override
  State<ExpectedAmount> createState() => _ExpectedAmountState();
}

class _ExpectedAmountState extends State<ExpectedAmount> {
  bool showDiscountText = false;
  double discount = 0.0;
  

  String savedValue = "";

  @override
  void initState() {
    super.initState();
    savedValue = widget.controller.text; 
  }

  void _calculateDiscount() {
    final expectedText = widget.controller.text.trim();
    if (expectedText.isEmpty) {
      setState(() => discount = 0.0);
      return;
    }

    final expected = double.tryParse(expectedText) ?? 0.0;
    final total = widget.total;
    final calculated = total - expected;

    setState(() {
      discount = calculated < 0 ? 0 : calculated;
    });

    widget.onDiscountCalculated?.call(discount);
    widget.onExpectedAmountEntered?.call(expected);
  }

  void _onChanged(String value) {
    savedValue = value;
    widget.onChanged?.call(value);

    if (showDiscountText) {
      _calculateDiscount();
    }
  }

  @override
  void didUpdateWidget(ExpectedAmount oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Restore the saved user input after any rebuild
    widget.controller.text = savedValue;

    // ❌ IMPORTANT: Do NOT recalculate discount here
    // Discount should only recalc when dropdown is opened.
  }

  // void _toggleDiscount() {
  //   setState(() {
  //     showDiscountText = !showDiscountText;
  //   });

  //   if (showDiscountText) {
  //     _calculateDiscount();
  //   }
  // }

  void _toggleDiscount() {
  setState(() {
    showDiscountText = !showDiscountText;
  });

  // Calculate ONLY the first time dropdown is opened
  if (showDiscountText && !discountCalculatedOnce) {
    _calculateDiscount();
    discountCalculatedOnce = true;
  }
}
  bool discountCalculatedOnce = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Expected Amount",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  onChanged: _onChanged,
                  decoration: InputDecoration(
                    hintText: "Enter amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              InkWell(
                onTap: _toggleDiscount,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    size: 28,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),

          if (showDiscountText) ...[
            const SizedBox(height: 8),
            Text(
              "Discount: Rs ${discount.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Text(
            //   "Jyala: Rs ${jyalaAmt.toStringAsFixed(3)}",
            //   style: const TextStyle(
            //     fontSize: 14,
            //     color: Colors.green,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ],
        ],
      ),
    );
  }
}

