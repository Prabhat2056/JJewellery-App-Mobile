  //--------------------------------------------------total calculation-------------------------------------------------
// void calcTotal(qrData) {
//     double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
//     double jartiGram = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
//     double rate = stringToDouble(qrData.rate);
//     double jyala = stringToDouble(qrData.jyala);
//     double stone1Price = stringToDouble(qrData.stone1Price ?? "0.000");
//     double stone2Price = stringToDouble(qrData.stone2Price ?? "0.000");
//     double stone3Price = stringToDouble(qrData.stone3Price ?? "0.000");

//     double baseAmount = qrData.jarti.trim().isEmpty
//         ? (netWeight * (rate / 11.664)) + jyala + stone1Price + stone2Price + stone3Price
//         : ((netWeight + jartiGram) * (rate / 11.664)) + jyala + stone1Price + stone2Price + stone3Price;

//     double luxuryAmount = baseAmount * 0.02;
//     double total = baseAmount + luxuryAmount;

//     qrData.baseAmount = baseAmount;
//     qrData.luxuryAmount = luxuryAmount;
//     qrData.total = total;
//   }


//----------------------------------------Reverse calculation total from expected----------------------------------------------
// void calcTotalFromExpectedAmount(qrData) {
//   // 1️⃣ Parse expected amount
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   log("🟢 Debug: expectedAmount → $expectedAmount");

//   if (expectedAmount == 0) {
//     calcLuxuryCalculations(qrData);
//     return;
//   }
//   else {
//     calcUpdatedData(qrData);
    
//    }
// }

// void calcTotalFromExpectedAmount(QrDataModel qrData) {
//   double stringToDoubleSafe(String v) => stringToDouble(v.toString());

//   print("🟢 Starting reverse calculation...");

//   // 1️⃣ Parse necessary fields
//   double expectedAmount = stringToDoubleSafe(qrData.expectedAmount);
//   double total = qrData.total;

//   double jartiAmount = stringToDoubleSafe(qrData.newJartiAmount);
//   double jyala = stringToDoubleSafe(qrData.newJyala);
//   double baseAmount = qrData.baseAmount;
//   double stoneTotal = stringToDoubleSafe(qrData.newStoneTotalPrice);

//   print("Parsed values -> Jyala: $jyala, Jarti: $jartiAmount, Base: $baseAmount, Stones: $stoneTotal");

//   // 2️⃣ Calculate discount
//   double discount = total - expectedAmount;
//   qrData.expectedAmountDiscount = discount;
//   print("Discount calculated: $discount");

//   // 3️⃣ Middle Section: Reverse Logic
//   print("🟡 Entering middle section (Jyala/Jarti deduction)");

//   double newJyala = jyala;
//   double newJartiAmount = jartiAmount;

//   if (discount <= jyala) {
//     // CASE 1 → Reduce Jyala only
//     newJyala = jyala - discount;
//     print("Discount <= Jyala, reducing Jyala only: $newJyala");
//   } else {
//     // CASE 2 → Remove full Jyala, remaining from Jarti
//     double remaining = discount - jyala;
//     newJyala = 0;
//     newJartiAmount = jartiAmount - remaining;
//     print("Discount > Jyala, Jyala set to 0, reducing Jarti: $newJartiAmount");
//   }

//   // Update QR data
//   qrData.newJyala = newJyala.toStringAsFixed(2);
//   qrData.newJartiAmount = newJartiAmount.toStringAsFixed(2);

//   // 4️⃣ Recalculate taxable amount
//   double taxableAmount = baseAmount + newJartiAmount + newJyala;
//   qrData.taxableAmount = taxableAmount;
//   print("Taxable amount recalculated: $taxableAmount");

//   // 5️⃣ Luxury tax (3%)
//   double luxuryAmount = taxableAmount * 0.03;
//   qrData.luxuryAmount = luxuryAmount;
//   print("Luxury amount (3%) calculated: $luxuryAmount");

//   // 6️⃣ Final total
//   double nonTaxable = qrData.nonTaxableAmount;
//   double finalTotal = taxableAmount + luxuryAmount + stoneTotal + nonTaxable;
//   qrData.total = finalTotal;
//   print("✅ Final total calculated: $finalTotal");

//   print("🟢 Reverse calculation completed.\n");
// }

 //----------------------------------------------------------------------------------------- 

//   // 4️⃣ Copy components into local variables
//   double netWeightAmount = netWeight * (rate / 11.664);
//   double jyalaAmt = jyala;
//   double jartiAmt = jartiAmount;
//   double stone1 = stone1Price;
//   double stone2 = stone2Price;
//   double stone3 = stone3Price;
  
//   // ignore: unused_local_variable
//   double stoneTotal = stone1Price + stone2Price + stone3Price;

//   // 5️⃣ Apply ExpectedAmountDiscount based on flow diagram
//   if (expectedAmountDiscount <= jyala) {
//     // Reduce Jyala only
//     NewJyala -= expectedAmountDiscount;
//     //jyala = jyalaAmt;
//   } else if (expectedAmountDiscount > jyalaAmt && expectedAmountDiscount <= jartiAmt) {
//     // Reduce Jarti only
//     jartiAmt -= expectedAmountDiscount;
//     jartiAmount = jartiAmt;
//   } else if (expectedAmountDiscount > jartiAmt) {
//     // Reduce Stones only
//     // if (stoneTotal > 0) {
//     //   double ratio = expectedAmountDiscount / stoneTotal;
//     //   stone1 *= (1 - ratio);
//     //   stone2 *= (1 - ratio);
//     //   stone3 *= (1 - ratio);
//     // }
//     stoneTotal -= expectedAmountDiscount;
//   }

//   // 6️⃣ Recalculate taxable amount (Jyala + Jarti + NetWeight)
//   double taxableAmount = netWeightAmount + jartiAmt + jyalaAmt;
//   double nonTaxableAmount = stone1 + stone2 + stone3;
//   double baseAmount = taxableAmount + nonTaxableAmount;

//   // 7️⃣ Apply luxury tax (2%) on taxable amount
//   double luxuryAmount = taxableAmount * 0.02;

//   // 8️⃣ Compute total
//   // ignore: unused_local_variable
//   double total = baseAmount + luxuryAmount;
  

//   // 9️⃣ Save updated amounts back to qrData
//   qrData.jyala = jyalaAmt.toStringAsFixed(3);
//   qrData.jarti = jartiAmt.toStringAsFixed(3);
//   qrData.stone1Price = stone1.toStringAsFixed(3);
//   qrData.stone2Price = stone2.toStringAsFixed(3);
//   qrData.stone3Price = stone3.toStringAsFixed(3);

//   // Update jyalaPercentage to reflect the discounted jyala
//  calcJyalaPercentage(qrData);
//  //calcJyala(qrData);

//   // 1️⃣0️⃣ Recalculate totals
//   calcLuxuryCalculations(qrData);
//   // ignore: invalid_use_of_visible_for_testing_member
// //emit(QrResultPriceChangedState(qrData: qrData));
//   //emit(QrResultExpectedAmountDiscountChangedState(qrData: qrData));
// }









//----------------------------------------Reverse calculation total from expected----------------------------------------------

// void calcTaxableAmount(qrData){
//   double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
//   double jartiGram = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
//   double rate = stringToDouble(qrData.rate);
//   double jyala = stringToDouble(qrData.jyala);

//   double netWeightAmount = netWeight * (rate / 11.664);
//   double jartiAmount = jartiGram * (rate / 11.664);
//   double jyalaAmt = jyala;

//   double taxableAmount = netWeightAmount + jartiAmount + jyalaAmt;
//   qrData.taxableAmount = taxableAmount;
// }
//----------------------------------------------------------------------------------------

// void calcUpdatedData(qrData) {
//   //double expectedAmount = stringToDouble(qrData.expectedAmount);
//      // 2️⃣ Parse expectedAmountDiscount
//   double expectedAmountDiscount =
//       stringToDouble(qrData.expectedAmountDiscount);
//       //print("🟢 Debug: expectedAmountDiscount → $expectedAmountDiscount");
//     //print('Parsed expectedAmountDiscount: $expectedAmountDiscount');   

//   // 3️⃣ Parse component values
//   double stone1Price = stringToDouble(qrData.stone1Price);
//   double stone2Price = stringToDouble(qrData.stone2Price);
//   double stone3Price = stringToDouble(qrData.stone3Price);
//   double netWeight = qrData.netWeight.trim().isEmpty
//       ? 0
//       : double.parse(qrData.netWeight);
//   double jarti = qrData.jarti.trim().isEmpty
//       ? 0
//       : double.parse(qrData.jarti);
//   double jyala = stringToDouble(qrData.jyala);
//   double rate = stringToDouble(qrData.rate);
 

//   double jartiAmount = jarti * (rate / 11.664);
//   double netWeightAmount = (netWeight+ jarti) * (rate / 11.664);
//   double stoneTotalPrice = stone1Price + stone2Price + stone3Price;

//   double newJyala = jyala;
//   double newJartiAmount = jartiAmount;
//   double newStone1Price = stone1Price;
//   double newStone2Price = stone2Price;
//   double newStone3Price = stone3Price;
//   double newStoneTotalPrice = stoneTotalPrice;


//   if (expectedAmountDiscount <= jyala) {
//     // Reduce Jyala only
//      newJyala = stringToDouble(qrData.newJyala);
//     newJyala = jyala - expectedAmountDiscount;
   
//    qrData.newJyala = newJyala.toStringAsFixed(2);
//   } else if (expectedAmountDiscount > jyala && expectedAmountDiscount <= jartiAmount) {
//     // Reduce Jarti only
//       newJartiAmount = jartiAmount- expectedAmountDiscount;
//     newJartiAmount = stringToDouble(qrData.newJartiAmount);

//     qrData.newJartiAmount = newJartiAmount.toStringAsFixed(2);
//   } else if (expectedAmountDiscount > jartiAmount) {
    
//      if (stoneTotalPrice > 0) {
//        double ratio = expectedAmountDiscount / stoneTotalPrice;
//        newStone1Price =stone1Price* (1 - ratio);
//        newStone2Price =stone2Price * (1 - ratio);
//        newStone3Price = stone3Price *(1 - ratio);
//      }
//    newStoneTotalPrice = stoneTotalPrice- expectedAmountDiscount;

//     qrData.newStoneTotalPrice = newStoneTotalPrice.toStringAsFixed(2);
//   }

//   qrData.newStone1Price = newStone1Price.toStringAsFixed(2);
//   qrData.newStone2Price = newStone2Price.toStringAsFixed(2);
//   qrData.newStone3Price = newStone3Price.toStringAsFixed(2);

// // 6️⃣ Recalculate taxable amount (Jyala + Jarti + NetWeight)

//   double taxableAmount = netWeightAmount + newJartiAmount + newJyala;
//   double nonTaxableAmount = newStone1Price + newStone2Price + newStone3Price;
//   double baseAmount = taxableAmount + nonTaxableAmount;

//   // 7️⃣ Apply luxury tax (2%) on taxable amount
//   double luxuryAmount = taxableAmount * 0.02;

//   // 8️⃣ Compute total
//   // ignore: unused_local_variable
//   double total = baseAmount + luxuryAmount;

//   qrData.taxableAmount = taxableAmount.toStringAsFixed(2);
//   qrData.nonTaxableAmount = nonTaxableAmount.toStringAsFixed(2);
//   qrData.baseAmount = baseAmount.toStringAsFixed(2);
//   qrData.luxuryAmount = luxuryAmount.toStringAsFixed(2);
//   qrData.total = total.toStringAsFixed(2);
//   }



  //------------------------------------expected amount--------------------------------------------------------------
  

  
//   void calcTotalFromExpectedAmount(qrData) {
//   // Parse expectedAmountDiscount
//    double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
//   // ignore: unrelated_type_equality_checks
//   if(expectedAmountDiscount == 0){
//     calcLuxuryCalculations(qrData);
//     return;
    
//   } else{
//     // Parse component values
//   double stone1Price = stringToDouble(qrData.stone1Price);
//   double stone2Price = stringToDouble(qrData.stone2Price);
//   double stone3Price = stringToDouble(qrData.stone3Price);
//   double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
//   double jarti = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
//   double jyala = stringToDouble(qrData.jyala);
//   double rate = stringToDouble(qrData.rate);

//   double jartiAmount = jarti * (rate / 11.664);
//   double netWeightAmount = (netWeight + jarti) * (rate / 11.664);
//   double stoneTotalPrice = stone1Price + stone2Price + stone3Price;

//   // Initialize new variables as Strings
//   String newJyala = jyala.toStringAsFixed(2);
//   String newJartiAmount = jartiAmount.toStringAsFixed(2);
//   String newStone1Price = stone1Price.toStringAsFixed(2);
//   String newStone2Price = stone2Price.toStringAsFixed(2);
//   String newStone3Price = stone3Price.toStringAsFixed(2);
//   String newStoneTotalPrice = stoneTotalPrice.toStringAsFixed(2);

//   if (expectedAmountDiscount <= jyala) {
//     // Reduce Jyala only
//     newJyala = (jyala - expectedAmountDiscount).toStringAsFixed(2);
//     qrData.newJyala = newJyala;
//   } else if (expectedAmountDiscount > jyala && expectedAmountDiscount <= jartiAmount) {
//     // Reduce Jarti only
//     newJartiAmount = (jartiAmount - expectedAmountDiscount).toStringAsFixed(2);
//     qrData.newJartiAmount = newJartiAmount;
//   } else if (expectedAmountDiscount > jartiAmount) {
//     // Reduce stones
//     if (stoneTotalPrice > 0) {
//       double ratio = expectedAmountDiscount / stoneTotalPrice;
//       newStone1Price = (stone1Price * (1 - ratio)).toStringAsFixed(2);
//       newStone2Price = (stone2Price * (1 - ratio)).toStringAsFixed(2);
//       newStone3Price = (stone3Price * (1 - ratio)).toStringAsFixed(2);
//     }
//     newStoneTotalPrice = (stoneTotalPrice - expectedAmountDiscount).toStringAsFixed(2);
//     qrData.newStoneTotalPrice = newStoneTotalPrice;
//   }

//   qrData.newStone1Price = newStone1Price;
//   qrData.newStone2Price = newStone2Price;
//   qrData.newStone3Price = newStone3Price;

//   // Recalculate taxable and non-taxable amounts
//   double taxableAmount = netWeightAmount + stringToDouble(newJartiAmount) + stringToDouble(newJyala);
//   double nonTaxableAmount = stringToDouble(newStone1Price) + stringToDouble(newStone2Price) + stringToDouble(newStone3Price);
//   double baseAmount = taxableAmount + nonTaxableAmount;

//   // Apply luxury tax
//   double luxuryAmount = taxableAmount * 0.02;

//   // Compute total
//   double total = baseAmount + luxuryAmount;

//   qrData.taxableAmount = taxableAmount.toStringAsFixed(2);
//   qrData.nonTaxableAmount = nonTaxableAmount.toStringAsFixed(2);
//   qrData.baseAmount = baseAmount.toStringAsFixed(2);
//   qrData.luxuryAmount = luxuryAmount.toStringAsFixed(2);
//   qrData.total = total.toStringAsFixed(2);
// }
//   }



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