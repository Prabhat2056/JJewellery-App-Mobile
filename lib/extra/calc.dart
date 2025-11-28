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



