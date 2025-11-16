//-------------------------------------------display jyala-----------------------------------------------  
// import 'package:flutter/material.dart';

// class ExpectedAmount extends StatefulWidget {
//   final TextEditingController controller;
//   final double totalAmount; // 🧮 total to compare with
//   final double jyala; // base jyala value
//   final void Function(double discount, double jyala)? onValuesChanged;

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.totalAmount,
//     required this.jyala,
//     this.onValuesChanged,
//   });

//   @override
//   State<ExpectedAmount> createState() => _ExpectedAmountState();
// }

// class _ExpectedAmountState extends State<ExpectedAmount> {
//   bool showDiscountText = false;
//   double discount = 0.0;
//   double calculatedJyala = 0.0;

//   void _calculateDiscountAndJyala() {
//     final expectedText = widget.controller.text.trim();
//     if (expectedText.isEmpty) {
//       setState(() {
//         discount = 0.0;
//         calculatedJyala = widget.jyala;
//       });
//       return;
//     }

//     final expected = double.tryParse(expectedText) ?? 0.0;
//     final total = widget.totalAmount;

//     final calculatedDiscount = total - expected;
//     double newJyala = widget.jyala;

//     // Apply jyala logic only if discount <= jyala
//     if (calculatedDiscount <= widget.jyala) {
//       newJyala = widget.jyala - calculatedDiscount;
//     }

//     setState(() {
//       discount = calculatedDiscount < 0 ? 0 : calculatedDiscount;
//       calculatedJyala = newJyala;
//     });

//     widget.onValuesChanged?.call(discount, calculatedJyala);
//   }

//   void _toggleDiscount() {
//     setState(() {
//       showDiscountText = !showDiscountText;
//     });

//     if (showDiscountText) {
//       _calculateDiscountAndJyala();
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

//           // Row with TextField + dropdown icon
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: widget.controller,
//                   keyboardType: TextInputType.number,
//                   onChanged: (val) {
//                     if (showDiscountText) _calculateDiscountAndJyala();
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

//           // Display discount and jyala below
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
//             const SizedBox(height: 4),
//             Text(
//               "Jyala: Rs ${calculatedJyala.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.blueGrey,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

//-------------------------------------------display discount and jarti-----------------------------------------------
// import 'package:flutter/material.dart';

// class ExpectedAmount extends StatefulWidget {
//   final TextEditingController controller;
//   final double totalAmount;
//   final double jyala;
//   final double jarti;
//   final double nonTaxableAmount;

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.totalAmount,
//     required this.jyala,
//     required this.jarti,
//     required this.nonTaxableAmount,
//   });

//   @override
//   State<ExpectedAmount> createState() => _ExpectedAmountState();
// }

// class _ExpectedAmountState extends State<ExpectedAmount> {
//   bool showDiscountText = false;
//   double discount = 0.0;

//   double? updatedJyala;
//   double? updatedJarti;
//   double? updatedStoneAmount;

//   void _calculateDiscount() {
//     final expectedText = widget.controller.text.trim();
//     if (expectedText.isEmpty) {
//       setState(() {
//         discount = 0.0;
//         updatedJyala = null;
//         updatedJarti = null;
//         updatedStoneAmount = null;
//       });
//       return;
//     }

//     final expected = double.tryParse(expectedText) ?? 0.0;
//     final total = widget.totalAmount;
//     final calculatedDiscount = total - expected;

//     double finalDiscount = calculatedDiscount < 0 ? 0 : calculatedDiscount;

//     double tempJyala = widget.jyala;
//     double tempJarti = widget.jarti;
//     double tempStone = widget.nonTaxableAmount;

//     if (finalDiscount <= tempJyala) {
//       tempJyala -= finalDiscount;
//     } else {
//       tempJyala = 0;
//     }

//     if (finalDiscount <= tempJarti) {
//       tempJarti -= finalDiscount;
//     } else {
//       tempJarti = 0;
//       // Remaining discount applied to stoneAmount if discount > jarti
//       tempStone -= finalDiscount;
//       if (tempStone < 0) tempStone = 0;
//     }

//     setState(() {
//       discount = finalDiscount;
//       updatedJyala = tempJyala;
//       updatedJarti = tempJarti;
//       updatedStoneAmount = tempStone;
//     });
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

//           // TextField + Dropdown Icon
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

//           // Show discount and updated amounts
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
//             const SizedBox(height: 4),
//             Text(
//               "Jyala: Rs ${updatedJyala?.toStringAsFixed(2) ?? '-'}",
//               style: const TextStyle(fontSize: 14, color: Colors.orange),
//             ),
//             Text(
//               "Jarti: Rs ${updatedJarti?.toStringAsFixed(2) ?? '-'}",
//               style: const TextStyle(fontSize: 14, color: Colors.orange),
//             ),
//             Text(
//               "Stone Amount: Rs ${updatedStoneAmount?.toStringAsFixed(2) ?? '-'}",
//               style: const TextStyle(fontSize: 14, color: Colors.blue),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';

// class ExpectedAmount extends StatefulWidget {
//   final TextEditingController controller;
//   final double totalAmount;
//   final double jyala;
//   final double jarti;
//   final double nonTaxableAmount;

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.totalAmount,
//     required this.jyala,
//     required this.jarti,
//     required this.nonTaxableAmount,
//   });

//   @override
//   State<ExpectedAmount> createState() => _ExpectedAmountState();
// }

// class _ExpectedAmountState extends State<ExpectedAmount> {
//   bool showDiscountText = false;
//   double discount = 0.0;
//   double updatedJyala = 0.0;
//   double updatedJarti = 0.0;
//   double updatedStone = 0.0;

//   void _calculateDiscount() {
//     final expectedText = widget.controller.text.trim();
//     if (expectedText.isEmpty) {
//       setState(() {
//         discount = 0;
//         updatedJyala = widget.jyala;
//         updatedJarti = widget.jarti;
//         updatedStone = widget.nonTaxableAmount;
//       });
//       return;
//     }

//     final expected = double.tryParse(expectedText) ?? 0.0;
//     discount = widget.totalAmount - expected;
//     if (discount < 0) discount = 0;

//     // Start with original amounts
//     updatedJyala = widget.jyala;
//     updatedJarti = widget.jarti;
//     updatedStone = widget.nonTaxableAmount;

//     // Apply discount
//     if (discount <= updatedJyala) {
//       updatedJyala -= discount;
//     } else if (discount <= updatedJarti) {
//       updatedJarti -= discount;
//     } else {
//       updatedStone -= discount;
//       if (updatedStone < 0) updatedStone = 0;
//     }

//     setState(() {});
//   }

//   void _toggleDiscount() {
//     setState(() {
//       showDiscountText = !showDiscountText;
//     });

//     if (showDiscountText) _calculateDiscount();
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

//           // Row with TextField and Icon
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

//           // Display discount and updated amounts
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
//             const SizedBox(height: 4),
//             Text(
//               "Jyala: Rs ${updatedJyala.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               "Jarti: Rs ${updatedJarti.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               "Stone Amount: Rs ${updatedStone.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 14),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
