// void calcTotalFromExpectedAmount(QrDataModel qrData) {
//   print("🟢 calcTotalFromExpectedAmount started");
  
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
  
//   print("🟢 Target - Expected Amount: $expectedAmount, Discount: $expectedAmountDiscount");
  
//   // If no expected amount, use normal calculation
//   if (expectedAmount == 0) {
//     qrData.newJyala = "";
//     qrData.newJarti = "";
//     qrData.newJartiAmount = "";
//     calcLuxuryCalculations(qrData);
//     return;
//   }
  
//   // Get original component values
//   double stone1Price = stringToDouble(qrData.stone1Price );
//   double stone2Price = stringToDouble(qrData.stone2Price );
//   double stone3Price = stringToDouble(qrData.stone3Price );
//   double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
//   // double originalJarti = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
//   // double originalJyala = stringToDouble(qrData.jyala);
//   double jyala = (qrData.newJyala.isNotEmpty && qrData.newJyala != "0.000")
//       ? stringToDouble(qrData.newJyala)
//       : stringToDouble(qrData.jyala);

//    double jarti = (qrData.newJarti.isNotEmpty && qrData.newJarti != "0.000")
//       ? stringToDouble(qrData.newJarti)
//       : stringToDouble(qrData.jarti);

//   double rate = stringToDouble(qrData.rate);
//   //double total = qrData.total;
  
  
//   // Calculate fixed components
//   double nonTaxableAmount = stone1Price + stone2Price + stone3Price;
//   double originalJartiAmount = jarti * (rate / 11.664);
//   double metalAmount = (netWeight + jarti) * (rate / 11.664);
  
//   print("🟢 Original Components:");
//   print("🟢   NonTaxable (Stones): $nonTaxableAmount");
//   print("🟢   Metal Amount: $metalAmount");
//   print("🟢   Original Jyala: $jyala, Original Jarti: $jarti, JartiAmount: $originalJartiAmount");
  
//   // Calculate required taxable amount using luxury formula:
//   // total = 1.02 * taxableAmount + nonTaxableAmount
//   // So: taxableAmount = (expectedAmount - nonTaxableAmount) / 1.02
  
//   double requiredTaxableAmount = (expectedAmount - nonTaxableAmount) / 1.02;
//   if (requiredTaxableAmount < 0) requiredTaxableAmount = 0;
  
//   double originalTaxableAmount = metalAmount + jyala;
//   double reductionNeeded = originalTaxableAmount - requiredTaxableAmount;
  
//   print("🟢 Calculation:");
//   print("🟢   Required Taxable Amount: $requiredTaxableAmount");
//   print("🟢   Original Taxable Amount: $originalTaxableAmount");
//   print("🟢   Reduction Needed: $reductionNeeded");
  
//   // Initialize with original values
//   double newJyala = jyala;
//   double newJarti = jarti;
//   double newJartiAmount = originalJartiAmount;
  
//   // Apply reduction strategy
//   if (reductionNeeded > 0) {
//     // CASE 1: Reduction needed ≤ Jyala → Reduce only from Jyala
//     if (reductionNeeded <= jyala) {
//       newJyala = jyala - reductionNeeded;
//       newJarti = jarti; // Jarti unchanged
//       newJartiAmount = originalJartiAmount; // Jarti amount unchanged
      
//       print("🟢 CASE 1: Reduced only from Jyala");
//       print("🟢   Jyala reduced by: $reductionNeeded");
//       print("🟢   New Jyala: $newJyala, Jarti unchanged: $newJarti");
//     }
//     // CASE 2: Reduction needed > Jyala → Reduce only from Jarti
//     else {
//       newJyala = jyala; // Jyala unchanged
      
//       // Calculate how much to reduce from jarti
//       double jartiReductionNeeded = reductionNeeded;
//       double newJartiAmount = originalJartiAmount - jartiReductionNeeded;
      
//       // Ensure jarti amount doesn't go negative
//       if (newJartiAmount < 0) newJartiAmount = 0;
      
//       // Calculate new jarti from new jarti amount
//       if (rate > 0) {
//         newJarti = (newJartiAmount * 11.664) / rate;
//       } else {
//         newJarti = 0;
//       }
      
//       print("🟢 CASE 2: Reduced only from Jarti");
//       print("🟢   Jarti reduced by: $jartiReductionNeeded");
//       print("🟢   Jyala unchanged: $newJyala");
//       print("🟢   New Jarti: $newJarti, New JartiAmount: $newJartiAmount");
//     }
//   } else {
//     // No reduction needed
//     print("🟢 No reduction needed");
//   }
  
//   // Update the fields
//   qrData.newJyala = newJyala.toStringAsFixed(3);
//   qrData.newJarti = newJarti.toStringAsFixed(3);
//   qrData.newJartiAmount = newJartiAmount.toStringAsFixed(3);
  
//   // Update main fields for luxury calculation
//   qrData.jyala = qrData.newJyala;
//   qrData.jarti = qrData.newJarti;
  
//   // Recalculate luxury amounts with adjusted values
//   calcLuxuryCalculations(qrData);
  
//   // Verify the result
//   double finalTotal = qrData.total;
//   double difference = (finalTotal - expectedAmount).abs();
  
//   print("🟢 Final Results:");
//   print("🟢   Expected: $expectedAmount, Calculated: $finalTotal");
//   print("🟢   Difference: $difference");
//   print("🟢   Final Jyala: ${qrData.jyala}, Final Jarti: ${qrData.jarti}");
  
//   if (difference > 0.01) {
//     print("🔴 WARNING: Total doesn't match expected amount! Difference: $difference");
//   }
// }


// on<QrResultExpectedAmountChangedEvent>((event, emit) {
//   print("🟢 QrResultExpectedAmountChangedEvent triggered");

//   // calcNewJyala(event.qrData);
//   // calcNewJartiAmount(event.qrData);
//   // calcLuxuryCalculations(event.qrData);
  
//   // Calculate expected amount discount first
//   double expectedAmount = stringToDouble(event.qrData.expectedAmount);
//   double total = stringToDouble(event.qrData.price);
//   print("🟢 Current Total: $total, Expected Amount: $expectedAmount");
//   double expectedAmountDiscount = total - expectedAmount;
//   if (expectedAmountDiscount < 0) expectedAmountDiscount = 0;
//   event.qrData.expectedAmountDiscount = expectedAmountDiscount.toStringAsFixed(3);
  
//   print("🟢 Expected Amount: $expectedAmount, Total: $total, Discount: $expectedAmountDiscount");
  
//   // Clear old calculated values
//   event.qrData.newJyala = "";
//   event.qrData.newJarti = "";
//   event.qrData.newJartiAmount = "";
//   event.qrData.newStone1Price = "";
//   event.qrData.newStone2Price = "";
//   event.qrData.newStone3Price = "";
  
//   // Apply discount logic based on conditions
//   double jyala = stringToDouble(event.qrData.jyala);
//   double jartiAmount = stringToDouble(event.qrData.jartiAmount);
  
//   if (expectedAmountDiscount > 0) {
//     if (expectedAmountDiscount <= jyala) {
//       // Apply to jyala
//       calcNewJyala(event.qrData);
//     } else if (expectedAmountDiscount <= jartiAmount) {
//       // Apply to jarti
//       calcNewJartiAmount(event.qrData);
//     } else {
//       // Apply to stone
//       calcNewStonePrice(event.qrData);
//     }
//   }
  
//   // Recalculate total with new values
//   calcTotalFromExpectedAmount(event.qrData);
  
//   print("🟢 After calculation - Total: ${event.qrData.total}");
//   print("🟢 Base: ${event.qrData.baseAmount}, Taxable: ${event.qrData.taxableAmount}");
//   print("🟢 Luxury: ${event.qrData.luxuryAmount}");
  
//   emit(QrResultExpectedAmountDiscountChangedState(
//     qrData: event.qrData, 
//     isUpdate: isUpdate, 
//     originalQrData: originalQrData
//   ));
// });


  //   on<QrResultExpectedAmountChangedEvent>((event, emit) {
  //      double expectedAmountDiscount = stringToDouble(event.qrData.expectedAmountDiscount);
  //      double jarti = stringToDouble(event.qrData.jarti);
  //      double rate = stringToDouble(event.qrData.rate);
  //     //  double jartiAmount = stringToDouble(event.qrData.jartiAmount);
  //      double jyala = stringToDouble(event.qrData.jyala);
  //       double jartiAmount = jarti * (rate / 11.664);
  //       jartiAmount= stringToDouble(event.qrData.jartiAmount);
  
  
      
  //     // calcNewJyala(event.qrData);
  //     // calcNewJartiAmount(event.qrData);
  //     print("🟢 After new calculations - jyala: ${event.qrData.jyala}, newJyala: ${event.qrData.newJyala}, jarti : ${event.qrData.jarti}, newJarti: ${event.qrData.newJarti}, jartiAmount: ${event.qrData.jartiAmount}, newJartiAmount: ${event.qrData.newJartiAmount}");
  //     //print("🟢 Expected Amount Discount: $expectedAmountDiscount, rate: $rate,jartiAmount: $jartiAmount");
  //     //calcLuxuryCalculations(event.qrData);
  //     calcTotalFromExpectedAmount(event.qrData);
  //     //print("🟢 After luxury calc - total: ${event.qrData.total}, luxury: ${event.qrData.luxuryAmount}");
  //     if (expectedAmountDiscount > 0 && expectedAmountDiscount < jyala){
  //    calcNewJyala(event.qrData);
  // }
  //    else  if(expectedAmountDiscount > jyala && expectedAmountDiscount <= jartiAmount){
  //      print("🟢 Expected Amount Discount: $expectedAmountDiscount, rate: $rate,jartiAmount: $jartiAmount");
  //       calcNewJartiAmount(event.qrData);
  //       calcJartiGram(event.qrData);
  //       calcJartiLal(event.qrData);
  //       calcJartiPercentage(event.qrData);
  //    }
  //     // else  {
  //     //     calcNewStonePrice( event.qrData);
  //     // }
     
      
  //    // calcTotalFromExpectedAmount(event.qrData);
      
  //     //emit(QrResultExpectedAmountDiscountChangedState(qrData: event.qrData));
  //     emit(QrResultExpectedAmountDiscountChangedState(qrData: event.qrData, isUpdate: isUpdate, originalQrData: originalQrData));
  //   });