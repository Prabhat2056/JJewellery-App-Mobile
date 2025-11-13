

// import 'package:flutter/material.dart';

// class ExpectedAmount extends StatefulWidget {
//   final TextEditingController controller;
//   final double totalAmount;
//   final void Function(double)? onDiscountCalculated;

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.totalAmount,
//     this.onDiscountCalculated,
//   });

//   @override
//   State<ExpectedAmount> createState() => _ExpectedAmountState();
// }

// class _ExpectedAmountState extends State<ExpectedAmount> {
//   bool showDiscountText = false;
//   double discount = 0.0;

//   void _calculateDiscount() {
//     final expectedText = widget.controller.text.trim();
//     if (expectedText.isEmpty) {
//       setState(() => discount = 0.0);
//       return;
//     }

//     final expected = double.tryParse(expectedText) ?? 0.0;
//     final total = widget.totalAmount;
//     final calculated = total - expected;

//     setState(() {
//       discount = calculated < 0 ? 0 : calculated;
//     });

//     widget.onDiscountCalculated?.call(discount);
//   }

//   void _toggleDiscount() {
//     setState(() {
//       showDiscountText = !showDiscountText;
//     });

//     if (showDiscountText) {
//       _calculateDiscount();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Text(
//             "Expected Amount",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 12),

//           // Row with TextField and Dropdown Icon
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: widget.controller,
//                   keyboardType: TextInputType.number,
//                   onChanged: (val) {
//                     if (showDiscountText) _calculateDiscount();
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Enter amount",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),

//               // Dropdown Icon only
//               InkWell(
//                 onTap: _toggleDiscount,
//                 borderRadius: BorderRadius.circular(8),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.arrow_drop_down_circle_outlined,
//                     size: 28,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // Show discount text
//           if (showDiscountText) ...[
//             const SizedBox(height: 8),
//             Text(
//               "Discount: Rs ${discount.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ExpectedAmount extends StatefulWidget {
  final TextEditingController controller;
  final double totalAmount; // 🧮 total to compare with
  final double jyala; // base jyala value
  final void Function(double discount, double jyala)? onValuesChanged;

  const ExpectedAmount({
    super.key,
    required this.controller,
    required this.totalAmount,
    required this.jyala,
    this.onValuesChanged,
  });

  @override
  State<ExpectedAmount> createState() => _ExpectedAmountState();
}

class _ExpectedAmountState extends State<ExpectedAmount> {
  bool showDiscountText = false;
  double discount = 0.0;
  double calculatedJyala = 0.0;

  void _calculateDiscountAndJyala() {
    final expectedText = widget.controller.text.trim();
    if (expectedText.isEmpty) {
      setState(() {
        discount = 0.0;
        calculatedJyala = widget.jyala;
      });
      return;
    }

    final expected = double.tryParse(expectedText) ?? 0.0;
    final total = widget.totalAmount;

    final calculatedDiscount = total - expected;
    double newJyala = widget.jyala;

    // Apply jyala logic only if discount <= jyala
    if (calculatedDiscount <= widget.jyala) {
      newJyala = widget.jyala - calculatedDiscount;
    }

    setState(() {
      discount = calculatedDiscount < 0 ? 0 : calculatedDiscount;
      calculatedJyala = newJyala;
    });

    widget.onValuesChanged?.call(discount, calculatedJyala);
  }

  void _toggleDiscount() {
    setState(() {
      showDiscountText = !showDiscountText;
    });

    if (showDiscountText) {
      _calculateDiscountAndJyala();
    }
  }

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

          // Row with TextField + dropdown icon
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    if (showDiscountText) _calculateDiscountAndJyala();
                  },
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

          // Display discount and jyala below
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
            const SizedBox(height: 4),
            Text(
              "Jyala: Rs ${calculatedJyala.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

