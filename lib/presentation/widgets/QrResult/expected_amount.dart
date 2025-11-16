
// //-------------------------------------------display discount-----------------------------------------------
// import 'package:flutter/material.dart';

// class ExpectedAmount extends StatefulWidget {
//   final TextEditingController controller;
//   final double total;
//   final void Function(double)? onDiscountCalculated;
//   final void Function(String)? onChanged;

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.total,
//     this.onDiscountCalculated,
//     this.onChanged,
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
//     final total = widget.total;
//     final calculated = total - expected;

//     setState(() {
//       discount = calculated < 0 ? 0 : calculated;
//     });

//     widget.onDiscountCalculated?.call(discount);
//   }

//   void _onChanged(String value) {
//     widget.onChanged?.call(value);
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
//                     _onChanged(val);
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


//-------------------------------------------display discount-----------------------------------------------
import 'package:flutter/material.dart';

class ExpectedAmount extends StatefulWidget {
  final TextEditingController controller;
  final double total;
  final void Function(double)? onDiscountCalculated;
  final void Function(String)? onChanged;

    //final void Function(double)? onExpectedAmountEntered;   // ⭐ NEW

  const ExpectedAmount({
    super.key,
    required this.controller,
    required this.total,
    this.onDiscountCalculated,
    this.onChanged, required Null Function(dynamic expected) onExpectedAmountEntered,
     //this.onExpectedAmountEntered,   // ⭐ NEW
  });

  @override
  State<ExpectedAmount> createState() => _ExpectedAmountState();
}

class _ExpectedAmountState extends State<ExpectedAmount> {
  bool showDiscountText = false;
  double discount = 0.0;

  String savedValue = ""; // ⭐ NEW: keeps text even on rebuild

  @override
  void initState() {
    super.initState();
    savedValue = widget.controller.text; // save initial value
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
    //widget.onExpectedAmountEntered?.call(expected);   // ⭐ Send expected amount to parent
  }

  void _onChanged(String value) {
    savedValue = value;                      // ⭐ NEW: keep value permanently
    widget.onChanged?.call(value);
  }

  @override
  void didUpdateWidget(ExpectedAmount oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.controller.text = savedValue;     // ⭐ NEW: restore value if parent rebuilds
  }

  void _toggleDiscount() {
    setState(() {
      showDiscountText = !showDiscountText;
    });

    if (showDiscountText) {
      _calculateDiscount();
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

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    //widget.onChanged?.call(val);
                    if (showDiscountText) _calculateDiscount();
                    _onChanged(val);
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
          ],
        ],
      ),
    );
  }
}
