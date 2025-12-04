//     void calcTotalFromExpectedAmount(qrData) {
//   // Parse expectedAmountDiscount
//    double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
//    print("🟢 Calculating total from expected amount discount: $expectedAmountDiscount");
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
//   //double jarti = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
//   //double jyala = stringToDouble(qrData.jyala);
//    double jyala = (qrData.newJyala.isNotEmpty && qrData.newJyala != "0.000")
//       ? stringToDouble(qrData.newJyala)
//       : stringToDouble(qrData.jyala);
//      double jarti = (qrData.newjarti.isNotEmpty && qrData.newjarti != "0.000")
//       ? stringToDouble(qrData.newjarti)
//       : stringToDouble(qrData.jarti);


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


// void calcTotalFromExpectedAmount(QrDataModel qrData) {
//   print("🟢 calcTotalFromExpectedAmount started");
  
//   double expectedAmount = stringToDouble(qrData.expectedAmount);
//   double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
  
//   print("🟢 Target - Expected Amount: $expectedAmount, Discount: $expectedAmountDiscount");
  
//   // If no expected amount, use normal calculation
//   if (expectedAmount == 0) {
//     calcLuxuryCalculations(qrData);
//     return;
//   }
  
//   // Get original component values
//   double stone1Price = stringToDouble(qrData.stone1Price );
//   double stone2Price = stringToDouble(qrData.stone2Price );
//   double stone3Price = stringToDouble(qrData.stone3Price );
//   double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
//   double originalJarti = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
//   double originalJyala = stringToDouble(qrData.jyala);
//   double rate = stringToDouble(qrData.rate);
//   //double total = qrData.total;
  
  
//   // Calculate fixed components
//   double nonTaxableAmount = stone1Price + stone2Price + stone3Price;
//   double originalJartiAmount = originalJarti * (rate / 11.664);
//   double metalAmount = (netWeight + originalJarti) * (rate / 11.664);
  
//   print("🟢 Original Components:");
//   print("🟢   NonTaxable (Stones): $nonTaxableAmount");
//   print("🟢   Metal Amount: $metalAmount");
//   print("🟢   Original Jyala: $originalJyala, Original Jarti: $originalJarti, JartiAmount: $originalJartiAmount");
  
//   // Calculate required taxable amount using luxury formula:
//   // total = 1.02 * taxableAmount + nonTaxableAmount
//   // So: taxableAmount = (expectedAmount - nonTaxableAmount) / 1.02
  
//   double requiredTaxableAmount = (expectedAmount - nonTaxableAmount) / 1.02;
//   if (requiredTaxableAmount < 0) requiredTaxableAmount = 0;
  
//   double originalTaxableAmount = metalAmount + originalJyala;
//   double reductionNeeded = originalTaxableAmount - requiredTaxableAmount;
  
//   print("🟢 Calculation:");
//   print("🟢   Required Taxable Amount: $requiredTaxableAmount");
//   print("🟢   Original Taxable Amount: $originalTaxableAmount");
//   print("🟢   Reduction Needed: $reductionNeeded");
  
//   // Initialize with original values
//   double newJyala = originalJyala;
//   double newJarti = originalJarti;
//   double newJartiAmount = originalJartiAmount;
  
//   // Apply reduction strategy
//   if (reductionNeeded > 0) {
//     // CASE 1: Reduction needed ≤ Jyala → Reduce only from Jyala
//     if (reductionNeeded <= originalJyala) {
//       newJyala = originalJyala - reductionNeeded;
//       newJarti = originalJarti; // Jarti unchanged
//       newJartiAmount = originalJartiAmount; // Jarti amount unchanged
      
//       print("🟢 CASE 1: Reduced only from Jyala");
//       print("🟢   Jyala reduced by: $reductionNeeded");
//       print("🟢   New Jyala: $newJyala, Jarti unchanged: $newJarti");
//     }
//     // CASE 2: Reduction needed > Jyala → Reduce only from Jarti
//     else {
//       newJyala = originalJyala; // Jyala unchanged
      
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


//   void calcTotal(qrData) {
//   late double netWeight;
//   if (qrData.netWeight.trim().isEmpty) {
//     netWeight = 0;
//   } else {
//     netWeight = double.parse(qrData.netWeight);
//   }
  
//   // Use newJyala if available for price calculation
//   double jyalaValue = (qrData.newJyala.isNotEmpty && qrData.newJyala != "0.000")
//       ? stringToDouble(qrData.newJyala)
//       : stringToDouble(qrData.jyala);

//   if (qrData.jarti.trim().isEmpty) {
//     qrData.total = doubleToString(
//         (netWeight * (stringToDouble(qrData.rate) / 11.664)) +
//             jyalaValue +
//             stringToDouble(qrData.stone1Price ?? "0.000") +
//             stringToDouble(qrData.stone2Price ?? "0.000") +
//             stringToDouble(qrData.stone3Price ?? "0.000"));
//     return;
//   }
//    if (qrData.netWeight.isEmpty) {
//       qrData.total = doubleToString((double.parse(qrData.jarti) *
//               (stringToDouble(qrData.rate) / 11.664)) +
//           stringToDouble(qrData.jyala) +
//           stringToDouble(qrData.stone1Price ?? "0.000") +
//           stringToDouble(qrData.stone2Price ?? "0.000") +
//           stringToDouble(qrData.stone3Price ?? "0.000"));
      
//       return;
//     }

//     qrData.total = doubleToString(
//         (((double.parse(qrData.netWeight) + double.parse(qrData.jarti)) *
//                 (stringToDouble(qrData.rate) / 11.664))) +
//             stringToDouble(qrData.jyala) +
//             stringToDouble(qrData.stone1Price ?? "0.000") +
//             stringToDouble(qrData.stone2Price ?? "0.000") +
//             stringToDouble(qrData.stone3Price ?? "0.000"));

//   // ... rest of calcPrice function
// }


//     on<QrResultJartiGramChangedEvent>((event, emit) {
//   print("🟢 QrResultJartiGramChangedEvent triggered");
//   print("🟢 jarti: ${event.qrData.jarti}");
  
//   // Clear any discount calculations when manually editing jarti
//   event.qrData.newJarti = "";
//   event.qrData.newJartiAmount = "";
  
//   calcJartiPercentage(event.qrData);
//   calcJartiLal(event.qrData); // Ensure jartiLal is updated
//   calcJyalaPercentage(event.qrData);
//   calcPrice(event.qrData);
//   calcLuxuryCalculations(event.qrData);
  
//   emit(QrResultPriceChangedState(qrData: event.qrData));
// });


//     on<QrResultJartiPercentageChangedEvent>((event, emit) {
// // Clear any discount calculations when manually editing percentage
//   event.qrData.newJarti = "";
//   event.qrData.newJartiAmount = "";
  
//   // Recalculate jarti from percentage
//   calcJartiGram(event.qrData);
//  calcJartiLal(event.qrData); // Ensure jartiLal is updated
//   calcJyalaPercentage(event.qrData);
//   calcPrice(event.qrData);
//   calcLuxuryCalculations(event.qrData);
  
//   print("🟢 After calculation - jarti: ${event.qrData.jarti}, jartiLal: ${event.qrData.jartiLal}");
  
//   emit(QrResultPriceChangedState(qrData: event.qrData));
// });


    



//     on<QrResultExpectedAmountChangedEvent>((event, emit) {
//   double expectedAmount = stringToDouble(event.qrData.expectedAmount);
  
//   if (expectedAmount > 0) {
//     // REVERSE CALCULATION: Expected amount is entered
//     // Calculate discount first
//     calcLuxuryCalculations(event.qrData);
//     double originalTotal = (event.qrData.total);
//     event.qrData.expectedAmountDiscount = (originalTotal - expectedAmount).toStringAsFixed(3);
    
//     // Reverse calculate components to match expected amount
//     calcTotalFromExpectedAmount(event.qrData);
    
//   } else {
//     // NORMAL CALCULATION: No expected amount
//     // Clear discount fields
//     event.qrData.expectedAmountDiscount = "0.000";
//     event.qrData.newJyala = "";
//     event.qrData.newJarti = "";
//     event.qrData.newJartiAmount = "";
    
//     // Normal forward calculation
//     calcLuxuryCalculations(event.qrData);
//   }
  
//   emit(QrResultExpectedAmountDiscountChangedState(
//     qrData: event.qrData, 
//     isUpdate: isUpdate, 
//     originalQrData: originalQrData
//   ));
// });

//     on<QrResultExpectedAmountChangedEvent>((event, emit) {
//   print("🟢 QrResultExpectedAmountChangedEvent triggered");
//   print("🟢 Expected Amount: ${event.qrData.expectedAmount}");
  
//   double expectedAmount = stringToDouble(event.qrData.expectedAmount);
//   calcNewJyala(event.qrData);
//       calcNewJartiAmount(event.qrData);
//   // First, calculate the original total using current values
//   calcLuxuryCalculations(event.qrData);
//   //double originalTotal = stringToDouble(event.qrData.total);
//   double originalTotal = event.qrData.total ;
  
//   // Calculate discount (for reference)
//   event.qrData.expectedAmountDiscount = (originalTotal - expectedAmount).toStringAsFixed(3);
  
//   print("🟢 Before Adjustment:");
//   print("🟢   Original Total: $originalTotal");
//   print("🟢   Expected Amount: $expectedAmount");
//   print("🟢   Discount: ${event.qrData.expectedAmountDiscount}");
  
//   // Use reverse calculation to make total equal expected amount
//   calcTotalFromExpectedAmount(event.qrData);
  
//   // Get final results
//   double finalTotal = (event.qrData.total);
//   double finalJyala = stringToDouble(event.qrData.jyala);
//   double originalJyala = stringToDouble(event.qrData.jyala);
//   double finalJarti = stringToDouble(event.qrData.jarti);
//   double originalJarti = event.qrData.jarti.trim().isEmpty ? 0 : double.parse(event.qrData.jarti);
  
//   bool jyalaReduced = finalJyala < originalJyala;
//   bool jartiReduced = finalJarti < originalJarti;
  
//   print("🟢 After Adjustment:");
//   print("🟢   Final Total: $finalTotal");
//   print("🟢   Jyala Reduced: $jyalaReduced (${originalJyala} → $finalJyala)");
//   print("🟢   Jarti Reduced: $jartiReduced (${originalJarti} → $finalJarti)");
//   print("🟢   Success: ${(finalTotal - expectedAmount).abs() < 0.01 ? 'YES' : 'NO'}");
  
//   emit(QrResultExpectedAmountDiscountChangedState(
//     qrData: event.qrData, 
//     isUpdate: isUpdate, 
//     originalQrData: originalQrData
//   ));
// });

  
//     on<QrResultResetToOriginalEvent>((event, emit) {
//   print("🟢 QrResultResetToOriginalEvent triggered");
  
//   // Create a fresh copy of the original data
//   QrDataModel resetData = QrDataModel(
//     id: originalQrData.id,
//     code: originalQrData.code,
//     item: originalQrData.item,
//     itemId: originalQrData.itemId,
//     materialId: originalQrData.materialId,
//     pcs: originalQrData.pcs,
//     metal: originalQrData.metal,
//     grossWeight: originalQrData.grossWeight,
//     netWeight: originalQrData.netWeight,
//     purity: originalQrData.purity,
//     jarti: originalQrData.jarti,
//     jartiLal: originalQrData.jartiLal,
//     jartiPercentage: originalQrData.jartiPercentage,
//     jyala: originalQrData.jyala,
//     jyalaPercentage: originalQrData.jyalaPercentage,
//     mrp: originalQrData.mrp,
//     price: originalQrData.price,
//     todayRate: originalQrData.todayRate,
//     rate: originalQrData.rate,
//     stone1Name: originalQrData.stone1Name,
//     stone1Id: originalQrData.stone1Id,
//     stone1Weight: originalQrData.stone1Weight,
//     stone1Price: originalQrData.stone1Price,
//     stone2Name: originalQrData.stone2Name,
//     stone2Id: originalQrData.stone2Id,
//     stone2Weight: originalQrData.stone2Weight,
//     stone2Price: originalQrData.stone2Price,
//     stone3Name: originalQrData.stone3Name,
//     stone3Id: originalQrData.stone3Id,
//     stone3Weight: originalQrData.stone3Weight,
//     stone3Price: originalQrData.stone3Price,
//     baseAmount: originalQrData.baseAmount,
//     nonTaxableAmount: originalQrData.nonTaxableAmount,
//     taxableAmount: originalQrData.taxableAmount,
//     luxuryAmount: originalQrData.luxuryAmount,
//     total: originalQrData.total,
//     expectedAmount: "", // Clear expected amount
//     expectedAmountDiscount: "", // Clear discount
//     newJyala: "", // Clear new calculated fields
//     newJyalaPercentage: "",
//     newJarti: "",
//     newJartiPercentage: "",
//     newJartiLal: "",
//     newJartiAmount: "",
//     newStone1Price: originalQrData.stone1Price,
//     newStone2Price: originalQrData.stone2Price,
//     newStone3Price: originalQrData.stone3Price,
//     newStoneTotalPrice: '',
//   );

//   // Recalculate with original data
//   calcJartiLal(resetData);
//   calcJartiPercentage(resetData);
//   calcJyalaPercentage(resetData);
//   calcTotal(resetData);
//   calcLuxuryCalculations(resetData);

//   emit(QrResultResetToOriginalState(
//     qrData: resetData,
//     isUpdate: isUpdate,
//     originalQrData: originalQrData,
//   ));
// });



//   on<QrResultExpectedAmountChangedEvent>((event, emit) {
//   print("🟢 QrResultExpectedAmountChangedEvent - Before calculations");
  
//   // Reset all calculated fields first
//   event.qrData.newJyala = "";
//   event.qrData.newJartiAmount = "";
//   event.qrData.newStone1Price = "";
//   event.qrData.newStone2Price = "";
//   event.qrData.newStone3Price = "";
//   event.qrData.discount = "no_discount";
  
//   // Calculate expected amount discount
//   calcExpectedAmountDiscount(event.qrData, null);
  
//   double discount = stringToDouble(event.qrData.expectedAmountDiscount);
//   double jyala = stringToDouble(event.qrData.jyala);
//   double jartiAmount = stringToDouble(event.qrData.jartiAmount);
  
//   if (discount <= 0) {
//     // No discount
//     event.qrData.discount = "no_discount";
//     event.qrData.newJyala = event.qrData.jyala;
//     event.qrData.newJartiAmount = event.qrData.jartiAmount;
//     event.qrData.newStone1Price = event.qrData.stone1Price;
//     event.qrData.newStone2Price = event.qrData.stone2Price;
//     event.qrData.newStone3Price = event.qrData.stone3Price;
//   } 
//   // Condition 1: Discount <= jyala → apply to jyala only
//   else if (discount <= jyala) {
//     calcNewJyala(event.qrData);
//   } 
//   // Condition 2: Discount > jyala AND discount <= jartiAmount → apply to jartiAmount only
//   else if (discount > jyala && discount <= jartiAmount) {
//     calcNewJartiAmount(event.qrData);
//   }
//   // Condition 3: Discount > jartiAmount → apply to stone price only
//   else if (discount > jartiAmount) {
//     calcNewStonePrice(event.qrData);
//   }
  
//   // Recalculate luxury with new values
//   calcLuxuryCalculations(event.qrData);
  
//   emit(QrResultExpectedAmountDiscountChangedState(
//     qrData: event.qrData, 
//     isUpdate: isUpdate, 
//     originalQrData: originalQrData
//   ));
// });

// on<QrResultExpectedAmountChangedEvent>((event, emit) {
//   print("🟢 QrResultExpectedAmountChangedEvent - Before calculations");
//   print("🟢 Discount amount: ${event.qrData.expectedAmountDiscount}");
//   print("🟢 Original jyala: ${event.qrData.jyala}, jartiAmount: ${event.qrData.jartiAmount}");
  
//   // Calculate expected amount discount first
//   double expectedAmount = stringToDouble(event.qrData.expectedAmount);
//   double total = (event.qrData.total);
//   double discount = total - expectedAmount;
//   if (discount < 0) discount = 0;
//   event.qrData.expectedAmountDiscount = discount.toStringAsFixed(3);
  
//   print("🟢 Calculated discount: $discount");
  
//   double jyala = stringToDouble(event.qrData.jyala);
//   double jartiAmount = stringToDouble(event.qrData.jartiAmount);
  
//   // Reset all new calculated fields
//   event.qrData.newJyala = "";
//   event.qrData.newJartiAmount = "";
//   event.qrData.newStone1Price = "";
//   event.qrData.newStone2Price = "";
//   event.qrData.newStone3Price = "";
  
//   // Apply discount based on conditions
//   if (discount <= 0) {
//     print("🟢 No discount to apply");
//     event.qrData.newJyala = event.qrData.jyala;
//     event.qrData.newJartiAmount = event.qrData.jartiAmount;
//     event.qrData.discount = "no_discount";
//   } 
//   else if (discount <= jyala) {
//     print("🟢 Applying discount to jyala");
//     double newJyala = jyala - discount;
//     event.qrData.newJyala = newJyala.toStringAsFixed(3);
//     event.qrData.newJartiAmount = event.qrData.jartiAmount;
//     event.qrData.discount = "applied_to_jyala";
//   } 
//   else if (discount <= jartiAmount) {
//     print("🟢 Applying discount to jartiAmount");
//     double newJartiAmount = jartiAmount - discount;
//     event.qrData.newJartiAmount = newJartiAmount.toStringAsFixed(3);
//     event.qrData.newJyala = event.qrData.jyala;
//     event.qrData.discount = "applied_to_jarti";
//   } 
//   else {
//     print("🟢 Should apply to stone price");
//     // Apply to highest stone price
//     double stone1Price = stringToDouble(event.qrData.stone1Price );
//     double stone2Price = stringToDouble(event.qrData.stone2Price );
//     double stone3Price = stringToDouble(event.qrData.stone3Price );
    
//     // Find highest stone price
//     double highestPrice = stone1Price;
//     String highestStone = "stone1";
    
//     if (stone2Price > highestPrice) {
//       highestPrice = stone2Price;
//       highestStone = "stone2";
//     }
//     if (stone3Price > highestPrice) {
//       highestPrice = stone3Price;
//       highestStone = "stone3";
//     }
    
//     if (discount <= highestPrice) {
//       double newStonePrice = highestPrice - discount;
//       switch (highestStone) {
//         case "stone1":
//           event.qrData.newStone1Price = newStonePrice.toStringAsFixed(3);
//           break;
//         case "stone2":
//           event.qrData.newStone2Price = newStonePrice.toStringAsFixed(3);
//           break;
//         case "stone3":
//           event.qrData.newStone3Price = newStonePrice.toStringAsFixed(3);
//           break;
//       }
//       event.qrData.discount = "applied_to_stone";
//     } else {
//       event.qrData.discount = "cannot_give";
//     }
    
//     event.qrData.newJyala = event.qrData.jyala;
//     event.qrData.newJartiAmount = event.qrData.jartiAmount;
//   }
  
//   // Recalculate luxury with new values
//   calcLuxuryCalculations(event.qrData);
  
//   print("🟢 After calculation - newJyala: ${event.qrData.newJyala}, newJartiAmount: ${event.qrData.newJartiAmount}");
  
//   emit(QrResultExpectedAmountDiscountChangedState(
//     qrData: event.qrData, 
//     isUpdate: isUpdate, 
//     originalQrData: originalQrData
//   ));
// });


//   on<QrResultExpectedAmountChangedEvent>((event, emit) {
//   print("🟢 QrResultExpectedAmountChangedEvent - Before calculations");
//   print("🟢 jyala: ${event.qrData.jyala}, newJyala: ${event.qrData.newJyala}");
  
//   double expectedAmountDiscount = stringToDouble(event.qrData.expectedAmountDiscount);
//   double jyala = stringToDouble(event.qrData.jyala);
//   double jartiAmount = stringToDouble(event.qrData.jartiAmount);
  
//   // Clear previous calculations
//   event.qrData.newJyala = "";
//   event.qrData.newJartiAmount = "";
//   event.qrData.newStone1Price = "";
//   event.qrData.newStone2Price = "";
//   event.qrData.newStone3Price = "";
  
//   // Determine where to apply discount
//   if (expectedAmountDiscount <= jyala) {
//     // Apply to Jyala
//     calcNewJyala(event.qrData);
//     print("🟢 Discount applied to Jyala");
//   } 
//   else if (expectedAmountDiscount <= jartiAmount && expectedAmountDiscount > jyala) {
//     // Apply to Jarti Amount
//     calcNewJartiAmount(event.qrData);
//     print("🟢 Discount applied to Jarti Amount");
//   }
//   else {
//     // Apply to Stones
//     calcNewStonePrice(event.qrData);
//     print("🟢 Discount applied to Stones");
//   }
  
//   calcLuxuryCalculations(event.qrData);
//   print("🟢 After luxury calc - total: ${event.qrData.total}, luxury: ${event.qrData.luxuryAmount}");
  
//   emit(QrResultExpectedAmountDiscountChangedState(
//     qrData: event.qrData, 
//     isUpdate: isUpdate, 
//     originalQrData: originalQrData
//   ));
// });