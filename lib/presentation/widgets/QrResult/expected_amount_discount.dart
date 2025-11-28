// import 'package:flutter/material.dart';
// import 'package:jjewellery/models/qr_data_model.dart';

// class ExpectedAmountPage extends StatefulWidget {
//   final TextEditingController controller;
//   final void Function(double)? onExpectedAmountEntered;
//   final QrDataModel qrData; // Add qrData to pass it to the BLoC


//   const ExpectedAmountPage({
//     super.key,
//     required this.controller, 
//     required this.qrData, // Make qrData required
//     this.onExpectedAmountEntered,
//     // required Null Function(dynamic expected) onExpectedAmountEntered,
    
//   });

//   @override
//   State<ExpectedAmountPage> createState() => _ExpectedAmountPageState();
// }

// class _ExpectedAmountPageState extends State<ExpectedAmountPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Expected Amount'),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16.0),

//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 8,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Enter Expected Amount:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//               ),

//               const SizedBox(height: 12),

//               TextField(
//                 controller: widget.controller,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Enter amount',
//                 ),
//               ),

//               const SizedBox(height: 20),

//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final discount = widget.controller.text;

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Discount applied for: Rs $discount'),
//                       ),
//                     );
//                   },
//                   child: const Text('Apply Discount'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:jjewellery/models/qr_data_model.dart';

class ExpectedAmountPage extends StatefulWidget {
  final TextEditingController controller;
  final void Function(double)? onExpectedAmountEntered;
  final double discount; // <-- parent sends this value
  final void Function(String)? onChanged;
  final QrDataModel qrData;

  const ExpectedAmountPage({
    super.key,
    this.onExpectedAmountEntered,
    required this.controller,
    required this.qrData,
    required this.discount,        // <--- required
    this.onChanged,
  });

  @override
  State<ExpectedAmountPage> createState() => _ExpectedAmountPageState();
}

class _ExpectedAmountPageState extends State<ExpectedAmountPage> {
  bool showDiscountText = false;
  String savedValue = "";

  @override
  void initState() {
    super.initState();
    savedValue = widget.controller.text;
  }

  void _onChanged(String value) {
    savedValue = value;
    widget.onChanged?.call(value);     // send input to parent for calculation
  }

  @override
  void didUpdateWidget(covariant ExpectedAmountPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // keep user's typed text
    widget.controller.text = savedValue;
  }

  void _toggleDiscount() {
    setState(() {
      showDiscountText = !showDiscountText;
    });
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
                  onChanged: _onChanged,
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

          // -----------------------------
          // DISCOUNT ONLY DISPLAYED, NOT CALCULATED
          // -----------------------------
          if (showDiscountText) ...[
            const SizedBox(height: 8),
            Text(
              "Discount: Rs ${widget.discount.toStringAsFixed(2)}",
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

