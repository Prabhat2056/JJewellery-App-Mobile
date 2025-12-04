


// //-------------------------------------------display discount-----------------------------------------------
// import 'package:flutter/material.dart';

// class ExpectedAmount extends StatefulWidget {
//   final TextEditingController controller;
//   final double total;
//   final void Function(double)? onDiscountCalculated;
//   final void Function(String)? onChanged;

//     final void Function(double)? onExpectedAmountEntered;   // ⭐ NEW

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.total,
//     this.onDiscountCalculated,
//     //this.onChanged, required Null Function(dynamic expected) onExpectedAmountEntered,
//     this.onChanged,
//      this.onExpectedAmountEntered,   // ⭐ NEW
//   });

//   @override
//   State<ExpectedAmount> createState() => _ExpectedAmountState();
// }

// class _ExpectedAmountState extends State<ExpectedAmount> {
//   bool showDiscountText = false;
//   double discount = 0.0;

//   String savedValue = ""; // ⭐ NEW: keeps text even on rebuild

//   @override
//   void initState() {
//     super.initState();
//     savedValue = widget.controller.text; // save initial value
//   }

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
//     widget.onExpectedAmountEntered?.call(expected);   // ⭐ Send expected amount to parent
//   }

//   void _onChanged(String value) {
//     savedValue = value;                      // ⭐ NEW: keep value permanently
//     widget.onChanged?.call(value);
//   }

//   @override
//   void didUpdateWidget(ExpectedAmount oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     widget.controller.text = savedValue;     // ⭐ NEW: restore value if parent rebuilds

//     if (oldWidget.total != widget.total) {
//       _calculateDiscount(); // Recalculate discount when total changes
//    }
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

//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: widget.controller,
//                   keyboardType: TextInputType.number,
//                   onChanged: (val) {
//                     //widget.onChanged?.call(val);
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
// void calcTotalFromExpectedAmount(qrData) {
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   if (expectedAmount == 0) {
//     calcLuxuryCalculations(qrData);
//     return;
//   }
//  double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount ?? "0.000");
//   double stone1Price = stringToDouble(qrData.stone1Price ?? "0.000");
//   double stone2Price = stringToDouble(qrData.stone2Price ?? "0.000");
//   double stone3Price = stringToDouble(qrData.stone3Price ?? "0.000");
//   double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
//   double jartiGram = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
//   double jyala = stringToDouble(qrData.jyala);
//   double rate = stringToDouble(qrData.rate);

//   double baseAmount = qrData.jarti.trim().isEmpty
//       ? (netWeight * (rate / 11.664)) + stone1Price + stone2Price + stone3Price+ jyala-expectedAmountDiscount
//       : ((netWeight + jartiGram) * (rate / 11.664)) + stone1Price + stone2Price + stone3Price+ jyala-expectedAmountDiscount;

//   double taxableAmount = baseAmount - (stone1Price + stone2Price + stone3Price)-expectedAmountDiscount;
//   if (taxableAmount < 0) taxableAmount = 0;

//   double luxuryAmount = taxableAmount * 0.02;
//   double currentTotal = baseAmount + luxuryAmount;

//   if (currentTotal == expectedAmount) return;

//    expectedAmountDiscount = currentTotal - expectedAmount;
//   if (expectedAmountDiscount < 0) expectedAmountDiscount = 0;

//   // Adjust jyala first
//     //jyala = stringToDouble(qrData.jyala);
//   // if ( expectedAmountDiscount <= jyala) {
//   //   jyala = jyala - expectedAmountDiscount;
//   //   jyala = 0;
//   // } else {
//   //   expectedAmountDiscount -= jyala;
//   //   jyala = 0;
//   // }

//   // Adjust jyala first
// if (expectedAmountDiscount <= jyala) {
//   jyala = jyala - expectedAmountDiscount;
//   expectedAmountDiscount = 0;
// } else {
//   expectedAmountDiscount -= jyala;
//   jyala = 0;
// }


//   // Adjust jarti if needed
//   double jarti = jartiGram;
//   if (expectedAmountDiscount > jyala && jarti >= expectedAmountDiscount) {
//     jarti = jarti - expectedAmountDiscount;
//     expectedAmountDiscount = 0;
//   } else if (expectedAmountDiscount > 0) {
//     expectedAmountDiscount -= jarti;
//     jarti = 0;
//   }

//   // Adjust stone amounts if needed
//   double stoneTotal = stone1Price + stone2Price + stone3Price;
//   if (expectedAmountDiscount > 0 && stoneTotal >= expectedAmountDiscount) {
//     double ratio = expectedAmountDiscount / stoneTotal;
//     stone1Price *= (1 - ratio);
//     stone2Price *= (1 - ratio);
//     stone3Price *= (1 - ratio);
//   } else if (expectedAmountDiscount > 0) {
//     stone1Price = 0;
//     stone2Price = 0;
//     stone3Price = 0;
//   }

//   // Update qrData
//   qrData.jyala = jyala.toStringAsFixed(3);
//   qrData.jarti = jarti.toStringAsFixed(3);
//   qrData.stone1Price = stone1Price.toStringAsFixed(3);
//   qrData.stone2Price = stone2Price.toStringAsFixed(3);
//   qrData.stone3Price = stone3Price.toStringAsFixed(3);

//   // Recalculate totals
//   calcLuxuryCalculations(qrData);
// }
//--------------------------------------------------------------------------------------

// void calcTotalFromExpectedAmount(qrData) {
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   if (expectedAmount == 0) {
//     calcLuxuryCalculations(qrData);
//     return;
//   }

//   double expectedAmountDiscount =
//       stringToDouble(qrData.expectedAmountDiscount ?? "0.000");

//   double stone1Price = stringToDouble(qrData.stone1Price ?? "0.000");
//   double stone2Price = stringToDouble(qrData.stone2Price ?? "0.000");
//   double stone3Price = stringToDouble(qrData.stone3Price ?? "0.000");
//   double netWeight = qrData.netWeight.trim().isEmpty
//       ? 0
//       : double.parse(qrData.netWeight);
//   double jartiGram = qrData.jarti.trim().isEmpty
//       ? 0
//       : double.parse(qrData.jarti);
//   double jyala = stringToDouble(qrData.jyala);
//   double rate = stringToDouble(qrData.rate);

//   double jartiAmount = jartiGram * (rate / 11.664);

//   // Step 1: Compute base amount
//   double baseAmount = (netWeight + jartiGram) * (rate / 11.664) +
//       stone1Price +
//       stone2Price +
//       stone3Price +
//       jyala -
//       expectedAmountDiscount;

//   double taxableAmount = baseAmount -
//       (stone1Price + stone2Price + stone3Price) -
//       expectedAmountDiscount;
//   if (taxableAmount < 0) taxableAmount = 0;

//   double luxuryAmount = taxableAmount * 0.02;
//   double currentTotal = baseAmount + luxuryAmount;

//   // Step 2: Recalculate expectedAmountDiscount if total != expectedAmount
//   if ((currentTotal - expectedAmount).abs() > 0.001) {
//     expectedAmountDiscount = currentTotal - expectedAmount;
//     if (expectedAmountDiscount < 0) expectedAmountDiscount = 0;
//   }

//   // Step 3: Adjust Jyala
//   if (expectedAmountDiscount <= jyala) {
//     jyala -= expectedAmountDiscount;
//     expectedAmountDiscount = 0;
//   } else {
//     expectedAmountDiscount -= jyala;
//     jyala = 0;
//   }

//   // Step 4: Adjust Jarti
//   double jarti = jartiAmount;
//   if (expectedAmountDiscount > 0) {
//     if (jarti >= expectedAmountDiscount) {
//       jarti -= expectedAmountDiscount;
//       expectedAmountDiscount = 0;
//     } else {
//       expectedAmountDiscount -= jarti;
//       jarti = 0;
//     }
//   }

//   // Step 5: Adjust Stone Prices proportionally
//   double stoneTotal = stone1Price + stone2Price + stone3Price;
//   if (expectedAmountDiscount > 0) {
//     if (stoneTotal >= expectedAmountDiscount && stoneTotal > 0) {
//       double ratio = expectedAmountDiscount / stoneTotal;
//       stone1Price *= (1 - ratio);
//       stone2Price *= (1 - ratio);
//       stone3Price *= (1 - ratio);
//       expectedAmountDiscount = 0;
//     } else {
//       stone1Price = 0;
//       stone2Price = 0;
//       stone3Price = 0;
//       expectedAmountDiscount = 0;
//     }
//   }

//   // Step 6: Save back to qrData
//   qrData.jyala = jyala.toStringAsFixed(3);
//   qrData.jarti = jarti.toStringAsFixed(3);
//   qrData.stone1Price = stone1Price.toStringAsFixed(3);
//   qrData.stone2Price = stone2Price.toStringAsFixed(3);
//   qrData.stone3Price = stone3Price.toStringAsFixed(3);

//   // Step 7: Recalculate totals
//   calcLuxuryCalculations(qrData);
// }

//----------------------------------------------------
// void calcTotalFromExpectedAmount(qrData) {
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   if (expectedAmount == 0) {
//     calcLuxuryCalculations(qrData);
//     return;
//   }

//   double expectedAmountDiscount =
//       stringToDouble(qrData.expectedAmountDiscount ?? "0.000");

//   double stone1Price = stringToDouble(qrData.stone1Price ?? "0.000");
//   double stone2Price = stringToDouble(qrData.stone2Price ?? "0.000");
//   double stone3Price = stringToDouble(qrData.stone3Price ?? "0.000");
//   double netWeight = qrData.netWeight.trim().isEmpty
//       ? 0
//       : double.parse(qrData.netWeight);
//   double jartiGram = qrData.jarti.trim().isEmpty
//       ? 0
//       : double.parse(qrData.jarti);
//   double jyala = stringToDouble(qrData.jyala);
//   double rate = stringToDouble(qrData.rate);

//   double jartiAmount = jartiGram * (rate / 11.664);

//   // Step 1: Compute base amount
//   double baseAmount =
//       (netWeight + jartiGram) * (rate / 11.664) + stone1Price + stone2Price + stone3Price + jyala - expectedAmountDiscount;

//   double taxableAmount = baseAmount - (stone1Price + stone2Price + stone3Price) - expectedAmountDiscount;
//   if (taxableAmount < 0) taxableAmount = 0;

//   double luxuryAmount = taxableAmount * 0.02;
//   double currentTotal = baseAmount + luxuryAmount;

//   // Step 2: Recalculate expectedAmountDiscount if total != expectedAmount
//   if ((currentTotal - expectedAmount).abs() > 0.001) {
//     expectedAmountDiscount = currentTotal - expectedAmount;
//     if (expectedAmountDiscount < 0) expectedAmountDiscount = 0;
//   }

//   // -------------------------------
//   // Step 3: Apply reverse discount to a single component ONLY
//   if (expectedAmountDiscount <= jyala) {
//     // Reduce from Jyala only
//     jyala -= expectedAmountDiscount;
//   } else if (expectedAmountDiscount > jyala && expectedAmountDiscount <= jartiAmount) {
//     // Reduce from JartiAmount only, leave Jyala untouched
//     jartiAmount -= expectedAmountDiscount;
//   } else if (expectedAmountDiscount > jartiAmount) {
//     // Reduce from Stones only, leave Jyala and Jarti untouched
//     double stoneTotal = stone1Price + stone2Price + stone3Price;
//     if (stoneTotal > 0) {
//       double ratio = expectedAmountDiscount / stoneTotal;
//       stone1Price *= (1 - ratio);
//       stone2Price *= (1 - ratio);
//       stone3Price *= (1 - ratio);
//     }
//   }

//   // Step 4: Save updated amounts back to qrData
//   qrData.jyala = jyala.toStringAsFixed(3);
//   qrData.jarti = jartiAmount.toStringAsFixed(3); // updated JartiAmount
//   qrData.stone1Price = stone1Price.toStringAsFixed(3);
//   qrData.stone2Price = stone2Price.toStringAsFixed(3);
//   qrData.stone3Price = stone3Price.toStringAsFixed(3);

//   // Step 5: Recalculate totals
//   calcLuxuryCalculations(qrData);
// }



// void calcTotalFromExpectedAmount(qrData) {
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   if (expectedAmount == 0) {
//     calcLuxuryCalculations(qrData);
//     return;
//   }

//   double expectedAmountDiscount =
//       stringToDouble(qrData.expectedAmountDiscount ?? "0.000");

//   double stone1Price = stringToDouble(qrData.stone1Price ?? "0.000");
//   double stone2Price = stringToDouble(qrData.stone2Price ?? "0.000");
//   double stone3Price = stringToDouble(qrData.stone3Price ?? "0.000");
//   double netWeight = qrData.netWeight.trim().isEmpty
//       ? 0
//       : double.parse(qrData.netWeight);
//   double jartiGram = qrData.jarti.trim().isEmpty
//       ? 0
//       : double.parse(qrData.jarti);
//   double jyala = stringToDouble(qrData.jyala);
//   double rate = stringToDouble(qrData.rate);

//   double jartiAmount = jartiGram * (rate / 11.664);

//   // Step 1: Compute base amounts for each component
//   double netWeightAmount = netWeight * (rate / 11.664);
//   double jartiAmt = jartiAmount; // separate variable for calculation
//   double jyalaAmt = jyala;
//   double stoneTotal = stone1Price + stone2Price + stone3Price;

//   // Step 2: Apply reverse discount to only the relevant component
//   if (expectedAmountDiscount <= jyalaAmt) {
//     // Reduce from Jyala only
//     jyalaAmt -= expectedAmountDiscount;
//   } else if (expectedAmountDiscount > jyalaAmt && expectedAmountDiscount <= jartiAmt) {
//     // Reduce from Jarti only, Jyala untouched
//     jartiAmt -= expectedAmountDiscount;
//   } else if (expectedAmountDiscount > jartiAmt) {
//     // Reduce from stones only, Jyala and Jarti untouched
//     if (stoneTotal > 0) {
//       // double ratio = expectedAmountDiscount / stoneTotal;
//       // stone1Price *= (1 - ratio);
//       // stone2Price *= (1 - ratio);
//       // stone3Price *= (1 - ratio);
//       stoneTotal -= expectedAmountDiscount;
//     }
//   }

//   // Step 3: Recalculate taxableAmount
//   double taxableAmount = netWeightAmount + jartiAmt + jyalaAmt;
//   double nonTaxableAmount = stone1Price + stone2Price + stone3Price;
//   double baseAmount = taxableAmount + nonTaxableAmount;

//   // Step 4: Apply luxury tax (2%)
//   double luxuryAmount = taxableAmount * 0.02;

//   // Step 5: Compute total
//   double total = taxableAmount + nonTaxableAmount + luxuryAmount;

//   // Step 6: Save updated amounts back to qrData
//   qrData.jyala = jyalaAmt.toStringAsFixed(3);
//   qrData.jarti = (jartiAmt).toStringAsFixed(3); // updated JartiAmount
//   qrData.stone1Price = stone1Price.toStringAsFixed(3);
//   qrData.stone2Price = stone2Price.toStringAsFixed(3);
//   qrData.stone3Price = stone3Price.toStringAsFixed(3);

//   // Step 7: Recalculate totals
//   calcLuxuryCalculations(qrData);
// }
// //----------------------------------------Reverse calculation total from expected v2----------------------------------------------


// //----------------------------------------Reverse calculation total from expected v2----------------------------------------------

// void calcTotalFromExpectedAmount(qrData) {
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   if (expectedAmount == 0) {
//     calcLuxuryCalculations(qrData);
//     return;
//   }

//   double expectedAmountDiscount =
//       stringToDouble(qrData.expectedAmountDiscount ?? "0.000");

//   // Original values (to maintain consistency across multiple recalculations)
//   final double originalJyala = stringToDouble(qrData.jyala);
//   final double originalJartiGram = qrData.jarti.trim().isEmpty
//       ? 0
//       : double.parse(qrData.jarti);
//   final double rate = stringToDouble(qrData.rate);
//   final double originalJartiAmount = originalJartiGram * (rate / 11.664);
//   final double originalStone1 = stringToDouble(qrData.stone1Price ?? "0.000");
//   final double originalStone2 = stringToDouble(qrData.stone2Price ?? "0.000");
//   final double originalStone3 = stringToDouble(qrData.stone3Price ?? "0.000");

//   // Step 1: Make local copies for calculation
//   double jyala = originalJyala;
//   double jartiAmt = originalJartiAmount;
//   double stone1Price = originalStone1;
//   double stone2Price = originalStone2;
//   double stone3Price = originalStone3;

//   // Step 2: Apply ExpectedAmountDiscount to only the relevant component
//   if (expectedAmountDiscount <= jyala) {
//     jyala -= expectedAmountDiscount;
//   } else if (expectedAmountDiscount > jyala && expectedAmountDiscount <= jartiAmt) {
//     jartiAmt -= expectedAmountDiscount;
//   } else if (expectedAmountDiscount > jartiAmt) {
//     double stoneTotal = stone1Price + stone2Price + stone3Price;
//     if (stoneTotal > 0) {
//       double ratio = expectedAmountDiscount / stoneTotal;
//       stone1Price *= (1 - ratio);
//       stone2Price *= (1 - ratio);
//       stone3Price *= (1 - ratio);
//     }
//   }

//   // Step 3: Compute taxable amount
//   double netWeight = qrData.netWeight.trim().isEmpty
//       ? 0
//       : double.parse(qrData.netWeight);
//   double netWeightAmount = netWeight * (rate / 11.664);
//   // double taxableAmount = netWeightAmount + jartiAmt + jyala + stone1Price + stone2Price + stone3Price;
// double baseAmount = netWeightAmount + jartiAmt + jyala + stone1Price + stone2Price + stone3Price;
// double nonTaxableAmount = stone1Price + stone2Price + stone3Price;
// double taxableAmount = baseAmount - nonTaxableAmount;

//   // Step 4: Apply luxury tax
//   double luxuryAmount = taxableAmount * 0.02;

//   // Step 5: Compute total
//   double currentTotal = taxableAmount + luxuryAmount;

//   // Step 6: Update qrData
//   qrData.jyala = jyala.toStringAsFixed(3);
//   qrData.jarti = (jartiAmt).toStringAsFixed(3);
//   qrData.stone1Price = stone1Price.toStringAsFixed(3);
//   qrData.stone2Price = stone2Price.toStringAsFixed(3);
//   qrData.stone3Price = stone3Price.toStringAsFixed(3);

//   // Step 7: Recalculate totals
//   calcLuxuryCalculations(qrData);
// }



// void calcTotalFromExpectedAmount(qrData) {
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   if (expectedAmount == 0) {
//     calcLuxuryCalculations(qrData);
//     return;
//   }

//   // ---- ORIGINAL VALUES (never modified) ----
//   double originalStone1 = stringToDouble(qrData.stone1PriceOriginal ?? qrData.stone1Price ?? "0");
//   double originalStone2 = stringToDouble(qrData.stone2PriceOriginal ?? qrData.stone2Price ?? "0");
//   double originalStone3 = stringToDouble(qrData.stone3PriceOriginal ?? qrData.stone3Price ?? "0");
//   double originalJartiGram = stringToDouble(qrData.jartiOriginal ?? qrData.jarti ?? "0");
//   double originalJyala = stringToDouble(qrData.jyalaOriginal ?? qrData.jyala ?? "0");
//   double netWeight = stringToDouble(qrData.netWeight);
//   double rate = stringToDouble(qrData.rate);

//   // Store originals back (only once)
//   qrData.stone1PriceOriginal = originalStone1.toString();
//   qrData.stone2PriceOriginal = originalStone2.toString();
//   qrData.stone3PriceOriginal = originalStone3.toString();
//   qrData.jartiOriginal = originalJartiGram.toString();
//   qrData.jyalaOriginal = originalJyala.toString();

//   // Convert jarti gram → amount
//   double originalJartiAmount = originalJartiGram * (rate / 11.664);

//   // Expected Amount Difference
//   double discount = stringToDouble(qrData.expectedAmountDiscount ?? "0");

//   // ---- WORKING COPIES (modifiable) ----
//   double jyalaAmt = originalJyala;
//   double jartiAmt = originalJartiAmount;
//   double stone1 = originalStone1;
//   double stone2 = originalStone2;
//   double stone3 = originalStone3;

//   double stoneTotal = stone1 + stone2 + stone3;

//   // ---- APPLY REVERSE DISCOUNT LOGIC ----
//   if (discount <= jyalaAmt) {
//     jyalaAmt -= discount;
//   }
//   else if (discount <= jartiAmt) {
//     jartiAmt -= discount;
//   }
//   else {
//     double remaining = discount - jartiAmt;

//     if (stoneTotal > 0) {
//       double ratio = remaining / stoneTotal;
//       stone1 *= (1 - ratio);
//       stone2 *= (1 - ratio);
//       stone3 *= (1 - ratio);
//     }
//   }

//   // ---- RECALCULATE ----
//   double netWeightAmount = netWeight * (rate / 11.664);
//   double taxableAmount = netWeightAmount + jyalaAmt + jartiAmt;
//   double stones = stone1 + stone2 + stone3;

//   double luxury = taxableAmount * 0.02;
//   double total = taxableAmount + stones + luxury;

//   // ---- SAVE BACK ----
//   qrData.jyala = jyalaAmt.toStringAsFixed(3);
//   qrData.jarti = (jartiAmt / (rate / 11.664)).toStringAsFixed(3);
//   qrData.stone1Price = stone1.toStringAsFixed(3);
//   qrData.stone2Price = stone2.toStringAsFixed(3);
//   qrData.stone3Price = stone3.toStringAsFixed(3);

//   calcLuxuryCalculations(qrData);
// }



//                             ExpectedAmount(
//   controller: expectedAmountController,
//   total: state.qrData.total,
//   onExpectedAmountEntered: (expected) {
//     // 1. Update qrData locally
//     state.qrData.expectedAmount = expected.toString();

//     // 2. Emit a BLoC event so UI rebuilds
//     BlocProvider.of<QrResultBloc>(context).add(
//       QrResultExpectedAmountChangedEvent(qrData: state.qrData),
//     );
//   },
//   onDiscountCalculated: (discount) {
//     state.qrData.expectedAmountDiscount = discount;
//     BlocProvider.of<QrResultBloc>(context).add(
//       QrResultExpectedAmountDiscountChangedEvent(qrData: state.qrData),
//     );
//   },
// ),

// ExpectedAmount(
//   controller: expectedAmountController,
//   total: state.qrData.total,
//   onChanged: (value) {  // Add this callback
//     state.qrData.expectedAmount = value;
//     BlocProvider.of<QrResultBloc>(context).add(
//       QrResultExpectedAmountChangedEvent(qrData: state.qrData),
//     );
//   },
//   onDiscountCalculated: (discount) {
//     setState(() {
//       state.qrData.expectedAmountDiscount = discount;
//     });
//   }, 
//   onExpectedAmountEntered: (expected) {
//     state.qrData.expectedAmount = expected.toString();
//     BlocProvider.of<QrResultBloc>(context).add(
//       QrResultExpectedAmountChangedEvent(qrData: state.qrData),
//     );
//   },
// ),


// void _updateControllersFromQrData(QrDataModel qr) {
  //   // Update controllers from the provided qr data
  //   itemController.text = qr.item;
  //   grossWeightController.text = qr.grossWeight;
  //   netWeightController.text = qr.netWeight;
  //   rateController.text = qr.rate;
  //   jyalaController.text = qr.jyala;
  //   jartiPercentageController.text = qr.jartiPercentage;
  //   jartiGramController.text = qr.jarti;
  //   jartiLalController.text = qr.jartiLal;
  //   jyalaPercentageController.text = qr.jyalaPercentage;
  //   stone1NameController.text = qr.stone1Name;
  //   stone2NameController.text = qr.stone2Name;
  //   stone3NameController.text = qr.stone3Name;
  //   stone1WeightController.text = qr.stone1Weight;
  //   stone2WeightController.text = qr.stone2Weight;
  //   stone3WeightController.text = qr.stone3Weight;
  //   stone1PriceController.text = qr.stone1Price;
  //   stone2PriceController.text = qr.stone2Price;
  //   stone3PriceController.text = qr.stone3Price;
  //   expectedAmountController.text = qr.expectedAmount;
  // }

  // builder: (context, state) {  //builder up
        //   //if (state is  QrResultInitialState || state is QrResultExpectedAmountDiscountChangedState) {
        //   if (state is QrResultInitialState) {
        //     originalQrData = state.originalQrData;

        //     itemController.text = state.qrData.item;
        //     grossWeightController.text = state.qrData.grossWeight;
        //     netWeightController.text = state.qrData.netWeight;
        //     rateController.text = state.qrData.rate;
        //     jyalaController.text = state.qrData.jyala;
        //     jartiPercentageController.text = state.qrData.jartiPercentage;
        //     jartiGramController.text = state.qrData.jarti;
        //     jartiLalController.text = state.qrData.jartiLal;
        //     jyalaPercentageController.text = state.qrData.jyalaPercentage;
        //     stone1NameController.text = state.qrData.stone1Name;
        //     stone2NameController.text = state.qrData.stone2Name;
        //     stone3NameController.text = state.qrData.stone3Name;
        //     stone1WeightController.text = state.qrData.stone1Weight;
        //     stone2WeightController.text = state.qrData.stone2Weight;
        //     stone3WeightController.text = state.qrData.stone3Weight;
        //     stone1PriceController.text = state.qrData.stone1Price;
        //     stone2PriceController.text = state.qrData.stone2Price;
        //     stone3PriceController.text = state.qrData.stone3Price;
        //     expectedAmountController.text = state.qrData.expectedAmount;

        //         }
            // else if (state is QrResultExpectedAmountDiscountChangedState) {// Update controllers with the new qrData values after expected amount discount change
            //           jyalaController.text = state.qrData.jyala;
            //       jartiPercentageController.text = state.qrData.jartiPercentage;
            //       jartiGramController.text = state.qrData.jarti;
            //       jartiLalController.text = state.qrData.jartiLal;
            //       jyalaPercentageController.text = state.qrData.jyalaPercentage;
            //       stone1PriceController.text = state.qrData.stone1Price;
            //       stone2PriceController.text = state.qrData.stone2Price;
            //       stone3PriceController.text = state.qrData.stone3Price;
            //       }

            //       } else if (state is QrResultExpectedAmountDiscountChangedState) {
            //   // Update controllers with the new qrData values after expected amount change
            //   itemController.text = state.qrData.item;
            //   grossWeightController.text = state.qrData.grossWeight;
            //   netWeightController.text = state.qrData.netWeight;
            //   rateController.text = state.qrData.rate;
            //   jyalaController.text = state.qrData.jyala;
            //   jartiPercentageController.text = state.qrData.jartiPercentage;
            //   jartiGramController.text = state.qrData.jarti;
            //   jartiLalController.text = state.qrData.jartiLal;
            //   jyalaPercentageController.text = state.qrData.jyalaPercentage;
            //   stone1NameController.text = state.qrData.stone1Name;
            //   stone2NameController.text = state.qrData.stone2Name;
            //   stone3NameController.text = state.qrData.stone3Name;
            //   stone1WeightController.text = state.qrData.stone1Weight;
            //   stone2WeightController.text = state.qrData.stone2Weight;
            //   stone3WeightController.text = state.qrData.stone3Weight;
            //   stone1PriceController.text = state.qrData.stone1Price;
            //   stone2PriceController.text = state.qrData.stone2Price;
            //   stone3PriceController.text = state.qrData.stone3Price;
            //   expectedAmountController.text = state.qrData.expectedAmount;
            //   // Add any other updates if needed
            // }

            // Update controllers when bloc emits price/expected changes so textfields show new values
            //   if (state is QrResultPriceChangedState ||
            //       state is QrResultInitialState ||
            //       state is QrResultExpectedAmountChangedState ||
            //       state is QrResultExpectedAmountDiscountChangedState) {
            //     // All these states contain an updated qrData object
            //     final qr = state.qrData;
            //     _updateControllersFromQrData(qr);
            //   }
            // },

            // // Rebuild the main UI for initial load and for price/expected-related state changes.
            //   buildWhen: (previous, current) =>
            //       current is QrResultInitialState ||
            //       current is QrResultPriceChangedState ||
            //       current is QrResultExpectedAmountChangedState ||
            //       current is QrResultExpectedAmountDiscountChangedState,

            //   builder: (context, state) {
            //     if (state is QrResultInitialState ||
            //         state is QrResultPriceChangedState ||
            //         state is QrResultExpectedAmountChangedState ||
            //         state is QrResultExpectedAmountDiscountChangedState) {
            //       // normalize to one state variable that contains qrData for building UI
            //       final currentState = state;
            //       final qrData = currentState.qrData;

            //       // store original only when initial state arrives
            //       if (state is QrResultInitialState) {
            //         originalQrData = state.originalQrData;
            //       }

            //       // ensure controllers reflect current qrData (safe to call; listener already updates too)
            //       _updateControllersFromQrData(qrData);





//-----------------------------------------

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jjewellery/bloc/QrResult/qr_result_bloc.dart';

// import 'package:jjewellery/models/qr_data_model.dart';

// class ExpectedAmount extends StatefulWidget { 
//   final TextEditingController controller;
//   final double total;
//   final void Function(double)? onDiscountCalculated;
//   final void Function(String)? onChanged;
//   final void Function(double)? onExpectedAmountEntered;
//   final QrDataModel qrData;

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.total,
//     required this.qrData,
//     this.onDiscountCalculated,
//     this.onChanged,
//     this.onExpectedAmountEntered,
//   });

//   @override
//   State<ExpectedAmount> createState() => _ExpectedAmountState();
// }

// class _ExpectedAmountState extends State<ExpectedAmount> {
//   bool showDiscountText = false;
//   double discount = 0.0;
//   String savedValue = "";
//   bool discountCalculatedOnce = false;
  

//   @override
//   void initState() {
//     super.initState();
//     savedValue = widget.controller.text;
//   }

//   void _calculateDiscount() {
//     final text = widget.controller.text.trim();

//     log("Starting _calculateDiscount with input text: '$text'");

//     // 1️⃣ If no input, reset discount and exit
//     if (text.isEmpty) {
//       setState(() => discount = 0.0);
//       widget.onDiscountCalculated?.call(0.0);
//       widget.onExpectedAmountEntered?.call(0.0);
//       log("Input is empty; discount reset to 0.0");
//       return;
//     }

//     // 2️⃣ Convert text to double safely
//     final expectedAmount = double.tryParse(text) ?? 0.0;
//     widget.qrData.expectedAmount = expectedAmount.toString();
//     log("Parsed expected amount: $expectedAmount");

//     // 3️⃣ Calculate discount = total – expectedAmount
//     final calculatedDiscount = widget.total - expectedAmount;
//     log("Calculated discount (total - expectedAmount): $calculatedDiscount");

//     // 4️⃣ Prevent negative discount
//     final finalDiscount = calculatedDiscount < 0 ? 0.0 : calculatedDiscount;
//     log("Final discount after preventing negatives: $finalDiscount");

//     // ⭐ Store raw value (ALWAYS parseable)
//     widget.qrData.expectedAmountDiscount = finalDiscount.toString();

//     // 5️⃣ Update UI
//     setState(() => discount = finalDiscount);

//     // 6️⃣ Notify parent widget
//     widget.onDiscountCalculated?.call(finalDiscount);
//     widget.onExpectedAmountEntered?.call(expectedAmount);
//     log("Discount Calculated → $discount | Expected Amount → $expectedAmount");
//   }

//   void _onChanged(String value) {
//     savedValue = value.trim();
//     widget.qrData.expectedAmount = savedValue;

//     // Optional callback to parent
//     widget.onChanged?.call(savedValue);

//     // Dispatch event to BLoC for calculation
//     final bloc = BlocProvider.of<QrResultBloc>(context);
//     bloc.add(QrResultExpectedAmountChangedEvent(
//       widget.qrData.expectedAmount, 
//       qrData: widget.qrData
//     ));

//     log("_onChanged: ExpectedAmount updated and event dispatched to BLoC");
//   }

//   @override
//   void didUpdateWidget(ExpectedAmount oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     widget.controller.text = savedValue;
//   }

//   void _toggleDiscount() {
//     log("_toggleDiscount called. Current showDiscountText: $showDiscountText, discountCalculatedOnce: $discountCalculatedOnce");
//     setState(() {
//       showDiscountText = !showDiscountText;
//     });
//     log("showDiscountText toggled to: $showDiscountText");
  
//     // Calculate ONLY the first time dropdown is opened
//     if (showDiscountText && !discountCalculatedOnce) {
//       log("Calling _calculateDiscount inside _toggleDiscount for the first time");
//       _calculateDiscount();
//       discountCalculatedOnce = false;
//       log("discountCalculatedOnce set to true");
//     }
//   }

//   // Helper method to parse double safely
//   double _safeParse(String value) {
//     return double.tryParse(value) ?? 0.0;
//   }

//   // Check if a field has been recalculated
//   bool _isFieldRecalculated(String originalValue, String newValue) {
//     return newValue.isNotEmpty && 
//            newValue != "0.000" && 
//            newValue != "0.0" && 
//            newValue != originalValue;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Parse all values
//     double jyala = _safeParse(widget.qrData.jyala);
//     double newJyala = _safeParse(widget.qrData.newJyala);
//     double jarti = _safeParse(widget.qrData.jarti);
//     double rate = _safeParse(widget.qrData.rate);
//     double jartiAmount = (jarti *rate)/11.664;
//     // double jartiAmount = _safeParse(widget.qrData.jartiAmount);
//     double newJartiAmount = _safeParse(widget.qrData.newJartiAmount);
    
//     double newJarti = _safeParse(widget.qrData.newJarti);
//     double jartiLal = _safeParse(widget.qrData.jartiLal);
//     double newJartiLal = _safeParse(widget.qrData.newJartiLal);

//     // Check which fields have been recalculated
//     bool isJyalaRecalculated = _isFieldRecalculated(
//       widget.qrData.jyala, 
//       widget.qrData.newJyala
//     );
    
//     bool isJartiAmountRecalculated = _isFieldRecalculated(
//       widget.qrData.jartiAmount, 
//       widget.qrData.newJartiAmount
//     );
    
//     bool isJartiRecalculated = _isFieldRecalculated(
//       widget.qrData.jarti, 
//       widget.qrData.newJarti
//     );
    
//     bool isJartiLalRecalculated = _isFieldRecalculated(
//       widget.qrData.jartiLal, 
//       widget.qrData.newJartiLal
//     );

//     log("🟢 Field Recalculation Status:");
//     log("🟢 Jyala: $isJyalaRecalculated (${widget.qrData.jyala} -> ${widget.qrData.newJyala})");
//     log("🟢 Jarti Amount: $isJartiAmountRecalculated (${widget.qrData.jartiAmount} -> ${widget.qrData.newJartiAmount})");
//     log("🟢 Jarti: $isJartiRecalculated (${widget.qrData.jarti} -> ${widget.qrData.newJarti})");
//     log("🟢 Jarti Lal: $isJartiLalRecalculated (${widget.qrData.jartiLal} -> ${widget.qrData.newJartiLal})");

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
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: widget.controller,
//                   keyboardType: TextInputType.number,
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
//                   onChanged: _onChanged,
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
//           if (showDiscountText) ...[
//             const SizedBox(height: 8),
            
//             // Always show discount and expected amount
//             Text(
//               "Discount: Rs ${discount.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
            
//             Text(
//               "Expected Amount: Rs ${widget.qrData.expectedAmount}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
            
//             const SizedBox(height: 8),
            
//             // JYALA SECTION - Only show if jyala was recalculated
//             if (isJyalaRecalculated) ...[
//               const Text(
//                 "--- Jyala Adjustment ---",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 "Original Jyala: Rs ${jyala.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 "Jyala After Discount: Rs ${newJyala.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.green,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//             ],
            
//             // JARTI AMOUNT SECTION - Only show if jarti amount was recalculated
//             if (isJartiAmountRecalculated) ...[
//               const Text(
//                 "--- Jarti Amount Adjustment ---",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 "Original Jarti Amount: Rs ${jartiAmount.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 "Jarti Amount After Discount: Rs ${newJartiAmount.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.green,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//             ],
            
//             // JARTI GRAM SECTION - Only show if jarti gram was recalculated
//             if (isJartiRecalculated) ...[
//               const Text(
//                 "--- Jarti Gram Adjustment ---",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 "Original Jarti (Gram): ${jarti.toStringAsFixed(2)}g",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 "Jarti After Discount: ${newJarti.toStringAsFixed(2)}g",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.green,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//             ],
            
//             // JARTI LAL SECTION - Only show if jarti lal was recalculated
//             if (isJartiLalRecalculated) ...[
//               const Text(
//                 "--- Jarti Lal Adjustment ---",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 "Original Jarti (Lal): ${jartiLal.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 "Jarti Lal After Discount: ${newJartiLal.toStringAsFixed(2)}",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.green,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//             ],
            
//             // Show message if no fields were recalculated
//             if (!isJyalaRecalculated && 
//                 !isJartiAmountRecalculated && 
//                 !isJartiRecalculated && 
//                 !isJartiLalRecalculated &&
//                 discount > 0) ...[
//               const Text(
//                 "No component adjustments needed",
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                   fontStyle: FontStyle.italic,
//                 ),
//               ),
//             ],
//           ],
//         ],
//       ),
//     );
//   }
// }

// }
//                             ExpectedAmount(
//                               controller: TextEditingController(text: state.qrData.expectedAmount),
//   total: state.qrData.total,
//   qrData: state.qrData,
//   onDiscountCalculated: (discount) {
//     // This will trigger the bloc event and calculations
//     state.qrData.expectedAmountDiscount = discount.toStringAsFixed(2);
//   },
//   onExpectedAmountEntered: (expected) {
//     state.qrData.expectedAmount = expected.toString();
//     BlocProvider.of<QrResultBloc>(context).add(
//       QrResultExpectedAmountChangedEvent(
//         state.qrData.expectedAmount, 
//         qrData: state.qrData
//       ),
//     );
//   }, 
// ),



//                             ExpectedAmount(
//   controller: TextEditingController(text: state.qrData.expectedAmount),
//   total: state.qrData.total,
//   qrData: state.qrData,
//   onDiscountCalculated: (discount) {
//     // This might not be needed if BLoC handles everything
//   },
//   onExpectedAmountEntered: (expected) {
//     // This is handled by BLoC event
//   },
//   onChanged: (value) {
//     // Trigger BLoC update
//     BlocProvider.of<QrResultBloc>(context).add(
//       QrResultExpectedAmountChangedEvent(
//         value, 
//         qrData: state.qrData
//       ),
//     );
//   }, 
// ),


//                            ExpectedAmount(
//   controller: TextEditingController(text: state.qrData.expectedAmount),
//   total: state.qrData.total,
//   qrData: state.qrData,
//   onDiscountCalculated: (discount) {
//     setState(() {
//       state.qrData.expectedAmountDiscount = discount.toStringAsFixed(2);
//     });
//   },
//   onExpectedAmountEntered: (expected) {
//     state.qrData.expectedAmount = expected.toString();
//     BlocProvider.of<QrResultBloc>(context).add(
//       QrResultExpectedAmountChangedEvent(
//         state.qrData.expectedAmount, 
//         qrData: state.qrData
//       ),
//     );
    
//     // Check if discount cannot be given
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (state.qrData.discount == "cannot_give") {
//         customToast("Discount is not given - exceeds stone price", ColorConstant.errorColor);
//       } else if (state.qrData.discount == "should_be_jarti") {
//         // This shouldn't happen with proper logic, but just in case
//         customToast("Discount should be applied to Jarti Amount, not stones", ColorConstant.warningColor);
//       }
//     });
//   }, 
// ),

//  if (state is QrResultExpectedAmountDiscountChangedState) {
//    // 🔴 CRITICAL FIX: Update jyalaController when discount is calculated
//     final displayJyala = (state.qrData.newJyala.isNotEmpty && 
//                          state.qrData.newJyala != "0.000")
//         ? state.qrData.newJyala
//         : state.qrData.jyala;
//     jyalaController.text = displayJyala;

//     final displayJyalaPercentage = (state.qrData.newJyalaPercentage.isNotEmpty && 
//                          state.qrData.newJyalaPercentage != "0.000")
//         ? state.qrData.newJyalaPercentage
//         : state.qrData.jyalaPercentage;
//     jyalaPercentageController.text = displayJyalaPercentage;
//             //Initialize new calculated fields controllers with values for UI display
//             // newjyalaController.text= state.qrData.newJyala ;
//             // newjyalaPercentageController.text= state.qrData.newJyalaPercentage;
//             // newjartiGramController.text= state.qrData.newJarti;
//             // newjartiPercentageController.text = state.qrData.newJartiPercentage;
//             // newjartiLalController.text= state.qrData.newJartiLal;
//             // newstone1PriceController.text= state.qrData.newStone1Price;
//             // newstone2PriceController.text= state.qrData.newStone2Price;
//             // newstone3PriceController.text= state.qrData.newStone3Price;
//  }
            



//-----------------------------------------



// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jjewellery/bloc/QrResult/qr_result_bloc.dart';

// import 'package:jjewellery/models/qr_data_model.dart';

// class ExpectedAmount extends StatefulWidget { 
//   final TextEditingController controller;
//   final double total;
//   final void Function(double)? onDiscountCalculated;
//   final void Function(String)? onChanged;
//   final void Function(double)? onExpectedAmountEntered;
//   final QrDataModel qrData; // Add qrData to pass it to the BLoC

//   const ExpectedAmount({
//     super.key,
//     required this.controller,
//     required this.total,
//     required this.qrData, // Make qrData required
//     this.onDiscountCalculated,
//     this.onChanged,
//     this.onExpectedAmountEntered,
//   });

//   @override
//   State<ExpectedAmount> createState() => _ExpectedAmountState();
// }

// class _ExpectedAmountState extends State<ExpectedAmount> {
//   bool showDiscountText = false;
//   double discount = 0.0;
//   String savedValue = "";
//   bool discountCalculatedOnce = false;
  

//   @override
//   void initState() {
//     super.initState();
//     savedValue = widget.controller.text;
//   }

//   // void _calculateDiscount() {
//   //   final expectedText = widget.controller.text.trim();
//   //   if (expectedText.isEmpty) {
//   //     setState(() => discount = 0.0);
//   //     return;
//   //   }

//   //   final expectedAmount = double.tryParse(expectedText) ?? 0.0;
//   //   final total = widget.total;
//   //   final calculated = total - expectedAmount;
    

//   //   setState(() {
//   //     discount = calculated < 0 ? 0 : calculated;
//   //   });

//   //   widget.onDiscountCalculated?.call(discount);
//   //   widget.onExpectedAmountEntered?.call(expectedAmount);
//   // }

//   void _calculateDiscount() {
//   final text = widget.controller.text.trim();

//   log("Starting _calculateDiscount with input text: '$text'");

//   // 1️⃣ If no input, reset discount and exit
//   if (text.isEmpty) {
//     setState(() => discount = 0.0);
//     widget.onDiscountCalculated?.call(0.0);
//     widget.onExpectedAmountEntered?.call(0.0);
//     log("Input is empty; discount reset to 0.0");
//     return;
//   }

//   // 2️⃣ Convert text to double safely
//   final expectedAmount = double.tryParse(text) ?? 0.0;
//   widget.qrData.expectedAmount = expectedAmount.toString();
//   log("Parsed expected amount: $expectedAmount");

//   // 3️⃣ Calculate discount = total – expectedAmount
//   final calculatedDiscount = widget.total - expectedAmount;
//   log("Calculated discount (total - expectedAmount): $calculatedDiscount");

  

//   // 4️⃣ Prevent negative discount
//   final finalDiscount = calculatedDiscount < 0 ? 0.0 : calculatedDiscount;
//   log("Final discount after preventing negatives: $finalDiscount");

//   // ⭐ Store raw value (ALWAYS parseable)
// widget.qrData.expectedAmountDiscount = finalDiscount.toString();

//   // 5️⃣ Update UI
//   setState(() => discount = finalDiscount);

//   // 6️⃣ Notify parent widget
//   widget.onDiscountCalculated?.call(finalDiscount);
//   widget.onExpectedAmountEntered?.call(expectedAmount);
//   log("Discount Calculated → $discount | Expected Amount → $expectedAmount");
// }

// //   void _onChanged(String value) {
// //   savedValue = value.trim();
// //   widget.qrData.expectedAmount = savedValue;

// //   // Optional callback to parent
// //   widget.onChanged?.call(savedValue);

// //   // // Dispatch event to BLoC
// //   // final bloc = BlocProvider.of<QrResultBloc>(context);
// //   // bloc.add(QrResultExpectedAmountChangedEvent(qrData: widget.qrData));

// //   log("_onChanged: ExpectedAmount updated and event dispatched to BLoC");
// // }

// void _onChanged(String value) {
//   savedValue = value.trim();
//   widget.qrData.expectedAmount = savedValue;

//   // 🔥 NEW: If expected amount is cleared, reset to original data
//   // if (savedValue.isEmpty) {
//   //   print("🟢 Expected amount cleared, triggering reset");
//   //   final bloc = BlocProvider.of<QrResultBloc>(context);
//   //   bloc.add(QrResultResetToOriginalEvent());
//   //   return;
//   // }

//   // Optional callback to parent
//   widget.onChanged?.call(savedValue);

//   // Dispatch event to BLoC for calculation
//   final bloc = BlocProvider.of<QrResultBloc>(context);
//   bloc.add(QrResultExpectedAmountChangedEvent(
//     widget.qrData.expectedAmount, 
//     qrData: widget.qrData
//   ));

//   log("_onChanged: ExpectedAmount updated and event dispatched to BLoC");
// }

//   @override
//   void didUpdateWidget(ExpectedAmount oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     // Restore the saved user input after any rebuild
//     widget.controller.text = savedValue;
//     // Update savedValue to the current controller text to avoid overriding new values
//     // savedValue = widget.controller.text;
//   }

//   void _toggleDiscount() {
//     log("_toggleDiscount called. Current showDiscountText: $showDiscountText, discountCalculatedOnce: $discountCalculatedOnce");
//     setState(() {
//       showDiscountText = !showDiscountText;
//     });
//     log("showDiscountText toggled to: $showDiscountText");
  
//     // Calculate ONLY the first time dropdown is opened
//     if (showDiscountText && !discountCalculatedOnce) {
//       log("Calling _calculateDiscount inside _toggleDiscount for the first time");
//       _calculateDiscount();
//       discountCalculatedOnce = false;
//       log("discountCalculatedOnce set to true");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//       double jyala = double.tryParse(widget.qrData.jyala.toString()) ?? 0.0;
//       double newJyala = double.tryParse(widget.qrData.newJyala.toString()) ?? 0.0;
//       double jartiAmount = double.tryParse(widget.qrData.jartiAmount.toString()) ?? 0.0;
//       double jarti = double.tryParse(widget.qrData.jarti.toString()) ?? 0.0;
//       //double rate = double.tryParse(widget.qrData.rate.toString()) ?? 0.0;
//       double newJartiAmount = double.tryParse(widget.qrData.newJartiAmount.toString()) ?? 0.0;
//       print( "jyala: $jyala, newJyala: $newJyala, jartiAmount: $jartiAmount, jarti: $jarti, newJartiAmount: $newJartiAmount");
//       // double newJartiAmount = (jarti * rate)/11.664;
//       // newJartiAmount = double.parse(newJartiAmount.toStringAsFixed(3));

    
//     //  double jyala = (qrData.newJyala.isNotEmpty && qrData.newJyala != "0.000")
//     //   ? stringToDouble(qrData.newJyala)
//     //   : stringToDouble(qrData.jyala);
//     //  double jarti = (qrData.newjarti.isNotEmpty && qrData.newjarti != "0.000")
//     //   ? stringToDouble(qrData.newjarti)
//     //   : stringToDouble(qrData.jarti);
   

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
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: widget.controller,
//                   keyboardType: TextInputType.number,
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

//    // *************** KEY LOGIC HERE ***************
//           // onChanged: (value) {
//           //   if (value.isEmpty) {
//           //     // USER CLEARED THE TEXT → RESET PAGE TO ORIGINAL DATA
//           //     context.read<QrResultBloc>().add(QrResultResetToOriginalEvent());
//           //     return;
//           //   }

//           //   // WHEN USER ENTERS VALUE → NORMAL FLOW
//           //   context.read<QrResultBloc>().add(
//           //         QrResultExpectedAmountChangedEvent(
//           //           qrData: widget.qrData,
//           //           expectedAmount: value,
//           //         ),
//           //       );
//           // },

//                    onChanged: _onChanged,
                  
//                   //  onChanged: (value){
//                   //    state.qrData.expectedAmount = value;
//                   //  }
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
//             Text(
//               "Jyala: Rs ${jyala.toStringAsFixed(2)}",
//               //"Jyala : Rs ${qrData.jyala}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               "Jyala After Discount: Rs ${newJyala.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               "Jarti : Rs ${jartiAmount.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               "Jarti After Discount: Rs ${newJartiAmount.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//              Text(
//               "Jarti (Gram): Rs ${jarti.toStringAsFixed(2)}",
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.green,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             Text(
//               //"Expected Amount: Rs ${widget.controller.text.trim().isEmpty ? '0.00' : double.tryParse(widget.controller.text.trim())?.toStringAsFixed(2) ?? '0.00'}",
//               "Expected Amount : Rs ${widget.qrData.expectedAmount.toString()}",
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
//     //   }
//     // );
//   }
// }

//---------------------------------------------------------