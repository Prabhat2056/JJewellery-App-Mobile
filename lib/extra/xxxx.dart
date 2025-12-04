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



//discount card
// import 'package:flutter/material.dart';

// class ExpectedAmount extends StatefulWidget {
//   final TextEditingController controller;
//   final double total;
//   final void Function(double)? onDiscountCalculated;

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.total,
//     this.onDiscountCalculated,
//   });

//   @override
//   State<ExpectedAmount> createState() => _ExpectedAmountState();
// }

// class _ExpectedAmountState extends State<ExpectedAmount> {
//   bool showDiscountText = false;
//   double discount = 0.0;

//   void _calculateDiscount() {
//     final input = widget.controller.text.trim();
//     if (input.isEmpty) {
//       setState(() => discount = 0.0);
//       widget.onDiscountCalculated?.call(0.0);
//       return;
//     }

//     final expected = double.tryParse(input) ?? 0.0;
//     final total = widget.total;

//     discount = (total - expected).clamp(0, double.infinity);

//     setState(() {});
//     widget.onDiscountCalculated?.call(discount); // ⭐ sends discount upward
//   }

//   void _toggle() {
//     setState(() => showDiscountText = !showDiscountText);
//     if (showDiscountText) _calculateDiscount();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Text(
//             "Expected Amount",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//           ),

//           const SizedBox(height: 12),

//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: widget.controller,
//                   keyboardType: TextInputType.number,
//                   onChanged: (_) {
//                     if (showDiscountText) _calculateDiscount();
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Enter amount",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),

//               InkWell(
//                 onTap: _toggle,
//                 child: const Icon(
//                   Icons.arrow_drop_down_circle_outlined,
//                   size: 30,
//                   color: Colors.black54,
//                 ),
//               )
//             ],
//           ),

//           if (showDiscountText) ...[
//             const SizedBox(height: 10),
//             Text(
//               "Discount: Rs ${discount.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             )
//           ]
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:jjewellery/models/qr_data_model.dart';

// class DiscountCard extends StatefulWidget {
//   const DiscountCard({
//     super.key,
//     required this.qrData,
//     required this.originalQrData,


//   });
//   final QrDataModel qrData;
//   final QrDataModel originalQrData;

//   @override
//   State<DiscountCard> createState() => _DiscountCardState();
// }
// class _DiscountCardState extends State<DiscountCard> {
//   bool isExpanded = false;
 
//   double stringToDouble(String value) {
//     String sanitizedValue = value.replaceAll(',', '').trim();
//     return double.tryParse(sanitizedValue) ?? 0.0;
//   }



//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width * 0.3;
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               isExpanded = !isExpanded;
//             });
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Rs. ${(stringToDouble(widget.originalQrData.price) - stringToDouble(widget.qrData.price)).toStringAsFixed(2)}",
                

//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//               Icon(
//                 isExpanded
//                     ? Icons.arrow_circle_up_rounded
//                     : Icons.arrow_circle_down_rounded,
//                 color: Colors.grey,
//               )
//             ],
//           ),
//         ),
//         !isExpanded
//             ? const SizedBox()
//             : Column(
//                 children: [
//                   const Divider(),
//                   const SizedBox(height: 2),
//                   _buildDiscountRow(
//                     t1: "Title",
//                     t2: "Actual",
//                     t3: "Discounted",
//                     width: width,
//                     isTitle: true,
//                   ),
//                   const SizedBox(height: 2),
//                   Divider(),
//                   _buildDiscountRow(
//                     t1: "Rate",
//                     t2: widget.originalQrData.rate,
//                     t3: widget.qrData.rate,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Net Wt.",
//                     t2: widget.originalQrData.netWeight,
//                     t3: widget.qrData.netWeight,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Jarti",
//                     t2: widget.originalQrData.jarti,
//                     t3: widget.qrData.jarti,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Jyala",
//                     t2: widget.originalQrData.jyala,
//                     t3: widget.qrData.jyala,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 1",
//                     t2: widget.originalQrData.stone1Price,
//                     t3: widget.qrData.stone1Price,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 2",
//                     t2: widget.originalQrData.stone2Price,
//                     t3: widget.qrData.stone2Price,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 3",
//                     t2: widget.originalQrData.stone3Price,
//                     t3: widget.qrData.stone3Price,
//                     width: width,
//                   ),
//                    Divider(color: const Color.fromARGB(255, 156, 69, 62),),
//                   _buildDiscountRow(
//                     t1: "Luxury Tax",
//                     t2: widget.originalQrData.luxuryAmount.toStringAsFixed(2),
//                     t3: widget.qrData.luxuryAmount.toStringAsFixed(2),
//                     width: width,
//                   ),
//                   Divider(color: const Color.fromARGB(255, 156, 69, 62),),
                  
//                   _buildDiscountRow(
//                       t1: "Total",
//                       t2: widget.originalQrData.total.toStringAsFixed(2),
//                       t3: widget.qrData.total.toStringAsFixed(2),
//                       width: width,
//                       isTitle: true),
//                 ],
//               )
//       ],
//     );
//   }

//   Widget _buildDiscountRow(
//       {required String t1,
//       required String t2,
//       required String t3,
//       required double width,
//       bool isTitle = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           width: width,
//           child: Text(
//             t1,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width,
//           child: Text(
//             t2,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width,
//           child: Text(
//             t3,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:jjewellery/models/qr_data_model.dart';

// class DiscountSummaryWidget extends StatefulWidget {

// const DiscountSummaryWidget({
//     super.key,
//     required this.originalQrData,
//     required this.qrData,
//   });

//   final QrDataModel originalQrData;
//   final QrDataModel qrData;

  

//   @override
//   State<DiscountSummaryWidget> createState() => _DiscountSummaryWidgetState();
// }

// class _DiscountSummaryWidgetState extends State<DiscountSummaryWidget> {
//   bool isExpanded = false;

//   double stringToDouble(String value) {
//     return double.tryParse(value) ?? 0.0;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width * 0.3;

//     // From second code
//     double itemDiscount =
//         // stringToDouble(widget.originalQrData.price) - stringToDouble(widget.qrData.price);
//         stringToDouble(widget.originalQrData.price).toStringAsFixed(2) - stringToDouble(widget.qrData.price).toStringAsFixed(2);

//     double expectedDiscount = widget.qrData.expectedAmountDiscount;
//     double totalDiscount = itemDiscount + expectedDiscount;


//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ----------------------------------------------------
//         //  UPPER ROW (summary total difference)
//         // ----------------------------------------------------
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               isExpanded = !isExpanded;
//             });
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 //"Rs. ${itemDiscount.toStringAsFixed(2)}",
//                 "Rs. ${totalDiscount.toStringAsFixed(2)}",

//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
//               Icon(
//                 isExpanded
//                     ? Icons.arrow_circle_up_rounded
//                     : Icons.arrow_circle_down_rounded,
//                 color: Colors.grey,
//               )
//             ],
//           ),
//         ),

//         // ----------------------------------------------------
//         //  EXPANDED DETAILS
//         // ----------------------------------------------------
//         !isExpanded
//             ? const SizedBox()
//             : Column(
//                 children: [
//                   const Divider(),
//                   const SizedBox(height: 2),
//                   _buildDiscountRow(
//                     t1: "Title",
//                     t2: "Actual",
//                     t3: "Discounted",
//                     width: width,
//                     isTitle: true,
//                   ),
//                   const Divider(),

//                   _buildDiscountRow(
//                     t1: "Rate",
//                     t2: widget.originalQrData.rate,
//                     t3: widget.qrData.rate,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Net Wt.",
//                     t2: widget.originalQrData.netWeight,
//                     t3: widget.qrData.netWeight,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Jarti",
//                     t2: widget.originalQrData.jarti,
//                     t3: widget.qrData.jarti,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Jyala",
//                     t2: widget.originalQrData.jyala,
//                     t3: widget.qrData.jyala,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 1",
//                     t2: widget.originalQrData.stone1Price,
//                     t3: widget.qrData.stone1Price,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 2",
//                     t2: widget.originalQrData.stone2Price,
//                     t3: widget.qrData.stone2Price,
//                     width: width,
//                   ),
//                   _buildDiscountRow(
//                     t1: "Stone 3",
//                     t2: widget.originalQrData.stone3Price,
//                     t3: widget.qrData.stone3Price,
//                     width: width,
//                   ),

//                   const Divider(color: Color.fromARGB(255, 156, 69, 62)),
//                   _buildDiscountRow(
//                     t1: "Luxury Tax",
//                     t2: widget.originalQrData.luxuryAmount.toStringAsFixed(2),
//                     t3: widget.qrData.luxuryAmount.toStringAsFixed(2),
//                     width: width,
//                   ),
//                   const Divider(color: Color.fromARGB(255, 156, 69, 62)),

//                   _buildDiscountRow(
//                     t1: "Total",
//                     t2: widget.originalQrData.total.toStringAsFixed(2),
//                     t3: widget.qrData.total.toStringAsFixed(2),
//                     width: width,
//                     isTitle: true,
//                   ),

//                   //const SizedBox(height: 12),

//                   // ----------------------------------------------------
//                   //  MERGED PART FROM THE SECOND CODE (TOTAL DISCOUNT)
//                   // ----------------------------------------------------
//                   // Container(
//                   //   padding: const EdgeInsets.all(14),
//                   //   decoration: BoxDecoration(
//                   //     color: Colors.white,
//                   //     borderRadius: BorderRadius.circular(16),
//                   //     boxShadow: const [
//                   //       BoxShadow(
//                   //         color: Colors.black12,
//                   //         blurRadius: 6,
//                   //         offset: Offset(0, 2),
//                   //       ),
//                   //     ],
//                   //   ),
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //     children: [
//                   //       const Text(
//                   //         "Discount",
//                   //         style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//                   //       ),
//                   //       Text(
//                   //         "Rs. ${totalDiscount.toStringAsFixed(2)}",
//                   //         style: const TextStyle(
//                   //           fontWeight: FontWeight.w600,
//                   //           fontSize: 16,
//                   //           color: Colors.green,
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                 ],
//               )
//       ],
//     );
//   }

//   Widget _buildDiscountRow({
//     required String t1,
//     required String t2,
//     required String t3,
//     required double width,
//     bool isTitle = false,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           width: width,
//           child: Text(
//             t1,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width,
//           child: Text(
//             t2,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         SizedBox(
//           width: width,
//           child: Text(
//             t3,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }




// double expectedAmount = stringToDouble(qrData.expectedAmount);
//    double total = qrData.total;
//    double expectedAmountDiscount = total - expectedAmount;
  //double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount ?? "0.000");
  //double initialDiscount = expectedAmountDiscount;
  


     // if (showDiscountText) ...[
          //   const SizedBox(height: 8),


          //   Text(
          //     "Expected Amount: Rs ${widget.qrData.expectedAmount}",
          //     style: const TextStyle(
          //       fontSize: 14,
          //       color: Colors.green,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          //   const SizedBox(height: 8),
            
          //   // Always show discount and expected amount
          //   Text(
          //     "Discount: Rs ${discount.toStringAsFixed(2)}",
          //     style: const TextStyle(
          //       fontSize: 14,
          //       color: Colors.green,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),

          //   Text(
          //       "Original Jyala: Rs ${jyala.toStringAsFixed(2)}",
          //       style: const TextStyle(
          //         fontSize: 14,
          //         color: Colors.green,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),

          //     Text(
          //       "Original Jarti Amount: Rs ${jartiAmount.toStringAsFixed(2)}",
          //       style: const TextStyle(
          //         fontSize: 14,
          //         color: Colors.green,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),

          //    Text(
          //         "Original Stone1Price :  ${stone1Price.toStringAsFixed(2)}",
          //           style: const TextStyle(
          //             fontSize: 14,
          //             color: Colors.green,
          //             fontWeight: FontWeight.w600,
          //           ),
          //       ),


            
            
            
          //   const SizedBox(height: 8),
            
          //   // JYALA SECTION - Only show if jyala was recalculated
          //   if (isJyalaRecalculated) ...[
          //     const Text(
          //       "--- Jyala Adjustment ---",
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: Colors.grey,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
              
          //     Text(
          //       "Jyala After Discount: Rs ${newJyala.toStringAsFixed(2)}",
          //       style: const TextStyle(
          //         fontSize: 14,
          //         color: Colors.blue,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     const SizedBox(height: 4),
          //   ],
            
          //    // JARTI AMOUNT SECTION - Only show if jarti amount was recalculated
          //  if (isJartiAmountRecalculated) ...[
          //     const Text(
          //       "--- Jarti Amount Adjustment ---",
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: Colors.grey,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
              

          //       //if (widget.qrData.newJartiAmount.isNotEmpty && widget.qrData.newJartiAmount != "0.000")
             
          //     Text(
          //       "Jarti Amount After Discount: Rs ${newJartiAmount.toStringAsFixed(2)}",
          //       style: const TextStyle(
          //         fontSize: 14,
          //         color: Colors.blue,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     const SizedBox(height: 4),
          //   ],
            
          //   // JARTI GRAM SECTION - Only show if jarti gram was recalculated
          //   if (isJartiRecalculated) ...[
          //     const Text(
          //       "--- Jarti Gram Adjustment ---",
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: Colors.grey,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     // Try calculating original jarti amount from jarti and rate
          //       Text(
          //         "Original Jarti :  ${jarti.toStringAsFixed(2)}",
          //           style: const TextStyle(
          //             fontSize: 14,
          //             color: Colors.green,
          //             fontWeight: FontWeight.w600,
          //           ),
          //       ),
          //     Text(
          //       "Jarti After Discount: ${newJarti.toStringAsFixed(2)}g",
          //       style: const TextStyle(
          //         fontSize: 14,
          //         color: Colors.blue,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     const SizedBox(height: 4),
          //   ],
            
          //   // Show message if no fields were recalculated
          //   // if (!isJyalaRecalculated && 
          //   //     !isJartiAmountRecalculated && 
          //   //     !isJartiRecalculated && 
          //   //     //!isJartiLalRecalculated &&
          //   //     discount > 0) ...[
          //   if (isStone1PriceRecalculated) ...[
          //     const Text(
          //       "---  Stone Price Adjusted  ---",
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: Colors.grey,
          //         fontStyle: FontStyle.italic,
          //       ),
          //     ),
             
          //     Text(
          //       "Stone1Price After Discount: ${newStone1Price.toStringAsFixed(2)}",
          //       style: const TextStyle(
          //         fontSize: 14,
          //         color: Colors.blue,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ],
          // ],

            // bool isJartiAmountRecalculated = _isFieldRecalculated(
    //   widget.qrData.jartiAmount, 
    //   widget.qrData.newJartiAmount
    // );


    // print("ExpectedAmount-jartiAmount calculated: $jartiAmount");
    //  //double jartiAmount = _safeParse(widget.qrData.jartiAmount);
    // double newJartiAmount = _safeParse(widget.qrData.newJartiAmount);
    
    // double newJarti = _safeParse(widget.qrData.newJarti);
    // double jartiLal = _safeParse(widget.qrData.jartiLal);
    // double newJartiLal = _safeParse(widget.qrData.newJartiLal);

     //  double jartiAmount = ((jarti *rate)/11.664).toDouble();
    //  print("ExpectedAmount-jartiAmount calculated: $jartiAmount");

      // ✅ FIX: Calculate jartiAmount properly
  // double jartiAmount;
  // if (widget.qrData.jartiAmount.isNotEmpty && widget.qrData.jartiAmount != "0.000") {
  //   // Use the value from qrData if available
  //   jartiAmount = _safeParse(widget.qrData.jartiAmount);
  // } else {
  //   // Calculate from jarti and rate
  //   jartiAmount = ((jarti * rate) / 11.664);
  // }