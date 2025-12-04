//import 'dart:developer';

import 'package:bloc/bloc.dart';
//import 'package:jjewellery/presentation/widgets/QrResult/expected_amount.dart';

import 'package:meta/meta.dart';

import '../../data/query/get_jewellery_rates.dart';
import '../../main_common.dart';
import '../../models/qr_data_model.dart';

part 'qr_result_event.dart';
part 'qr_result_state.dart';

class QrResultBloc extends Bloc<QrResultEvent, QrResultState> {

  late bool isUpdate;//
  late QrDataModel originalQrData;//
  //bool isUpdate = false;

  

  double stringToDouble(String value) {
    String sanitizedValue = value.replaceAll(',', '').trim();
    return double.tryParse(sanitizedValue) ?? 0.0;
  }

  String doubleToString(double value) {
    String formattedValue = value.toStringAsFixed(2);
    List<String> parts = formattedValue.split('.');
    // Format the integer part with commas
    String integerPart = parts[0]
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');

    return '$integerPart.${parts[1]}';
  }

  



  void calcJyalaPercentage(qrData, {bool isManualEdit = false}) {
  // Determine which jyala value to use for calculation
  double jyalaValue;
  bool usingNewJyala = false;

  // If user is manually editing jyala, always use the original jyala value
  if (isManualEdit) {
    jyalaValue = stringToDouble(qrData.jyala);
  } 
  
  // Check if newJyala is available and valid for calculation
  else if (qrData.newJyala.isNotEmpty && 
      qrData.newJyala != "0.000" && 
      double.tryParse(qrData.newJyala) != null &&
      double.parse(qrData.newJyala) > 0) {
    jyalaValue = double.parse(qrData.newJyala);
    usingNewJyala = true;
    print("🟢 Using newJyala: $jyalaValue");
  } else {
    // Fall back to original jyala
    jyalaValue = stringToDouble(qrData.jyala);
    usingNewJyala = false;
    print("🟢 Using original jyala: $jyalaValue");

  }
  
  final double rate = stringToDouble(qrData.rate);
  late double jarti;
  late double netWeight;
  
  // Determine which jarti value to use
  if (qrData.jarti.trim().isEmpty) {
    jarti = 0;
  } else {
    // Use newJarti if available and we're using newJyala
    if (usingNewJyala && qrData.newJarti.isNotEmpty && qrData.newJarti != "0.000") {
      jarti = double.parse(qrData.newJarti);
    } else {
      jarti = double.parse(qrData.jarti);
    }
  }
  
  if (qrData.netWeight.trim().isEmpty) {
    netWeight = 0;
  } else {
    netWeight = double.parse(qrData.netWeight);
  }
  
  if (netWeight == 0 && jarti == 0) {
    qrData.jyalaPercentage = "0.000";
    return;
  }
  
  // Calculate the percentage
  double percentage = ((jyalaValue * 100) / ((rate / 11.664) * (netWeight + jarti)));
  qrData.jyalaPercentage = percentage.toStringAsFixed(2);
  
  if (qrData.jyalaPercentage == "NaN") {
    qrData.jyalaPercentage = "0.000";
  }
  print("🟢 Final jyalaPercentage: ${qrData.jyalaPercentage}");
  calcLuxuryCalculations(qrData); // Recalculate luxury after jyala percentage change
  
}

  void calcJyala(qrData) {
    
    late double jyalaPercentage;
    if (qrData.jyalaPercentage.trim().isEmpty) {
      jyalaPercentage = 0;
    } else {
      jyalaPercentage = double.parse(qrData.jyalaPercentage);
    }

    qrData.jyala =
        ((double.parse(qrData.netWeight) + double.parse(qrData.jarti)) *
                (jyalaPercentage / 100) *
                (stringToDouble(qrData.rate) / 11.664))
            .toStringAsFixed(3);
    
  }



  void calcJartiGram(qrData) {
  // Priority 1: Calculate from newJartiAmount if available (discount calculation)
  if (qrData.newJartiAmount.isNotEmpty && qrData.newJartiAmount != "0.000") {
    if (qrData.rate.trim().isEmpty) {
      qrData.newJarti = "0.000";
      return;
    }

    try {
      double jartiAmount = double.parse(qrData.newJartiAmount);
      double rate = stringToDouble(qrData.rate);
      
      if (rate == 0) {
        qrData.newJarti = "0.000";
        return;
      }

      // Calculate jarti from jartiAmount using: jarti = (jartiAmount * 11.664) / rate
      double jarti = (jartiAmount * 11.664) / rate;
      qrData.newJarti = jarti.toStringAsFixed(6);
      qrData.jarti = qrData.newJarti; // Also update original jarti
      
      print("🟢 calcJartiGram (from Amount) - jartiAmount: $jartiAmount, rate: $rate, calculated jarti: ${qrData.newJarti}");
    } catch (e) {
      qrData.newJarti = "0.000";
      qrData.jarti = "0.000";
      print("🔴 Error in calcJartiGram (from Amount): $e");
    }
    return;
  }
  
  // Priority 2: Calculate from jartiPercentage (original calculation)
  if (qrData.jartiPercentage.trim().isEmpty ||
      qrData.jartiPercentage == "0.000") {
    qrData.jarti = "0.000";
    qrData.newJarti = "0.000";
    return;
  }

  // Original percentage-based calculation: jarti = (jartiPercentage / 100) * netWeight
  double jarti = ((double.parse(qrData.jartiPercentage) / 100) *
          double.parse(qrData.netWeight))
      ;
  
  qrData.jarti = jarti;
  qrData.newJarti = jarti;
  
  print("🟢 calcJartiGram (from Percentage) - jartiPercentage: ${qrData.jartiPercentage}, netWeight: ${qrData.netWeight}, calculated jarti: $jarti");
}

  void calcJartiPercentage(qrData) {
    if (qrData.netWeight.trim().isEmpty ||
        qrData.netWeight == "0" ||
        qrData.jarti.trim().isEmpty ||
        qrData.jarti == "0") {
      qrData.jartiPercentage = "0.000";
      return;
    }

    try {
      final double netWeight = double.parse(qrData.netWeight);
      final double jarti = double.parse(qrData.jarti);
      qrData.jartiPercentage = ((jarti / netWeight) * 100).toStringAsFixed(2);
    } catch (e) {
      qrData.jartiPercentage = "0.000";
    }
  }


  void calcJartiLal(qrData) {
  // Determine which jarti value to use
  double jartiValue;
  
  if (qrData.newJarti.isNotEmpty && qrData.newJarti != "0.000") {
    jartiValue = double.parse(qrData.newJarti);
    print("🟢 calcJartiLal - using newJarti: $jartiValue");
  } else if (qrData.jarti.trim().isEmpty || qrData.jarti == "0") {
    qrData.jartiLal = "0.000";
    return;
  } else {
    jartiValue = double.parse(qrData.jarti);
  }

  if (jartiValue == 0) {
    qrData.jartiLal = "0.000";
    return;
  }

  qrData.jartiLal = (jartiValue * (100 / 11.664)).toStringAsFixed(3);
  print("🟢 calcJartiLal - jarti: $jartiValue, jartiLal: ${qrData.jartiLal}");
}

  

  void calcjartiAmount(qrData){
       if (qrData.jarti.trim().isEmpty ||
        qrData.jarti == "0" ||
        qrData.rate.trim().isEmpty) {
      qrData.jartiAmount = "0.000";
      return;
   }

    try {
      final double jarti = double.parse(qrData.jarti);
      final double rate = double.parse(qrData.rate);
      qrData.jartiAmount = (jarti * (rate / 11.664)).toStringAsFixed(3);
   } catch (e) {
     qrData.jartiAmount = "0.000";
    }
   
  }
  

  

  //---------------------------------------luxury calculation-----------------------------------------------------------

  void calcLuxury(qrData) {
    double luxuryPercentage = double.tryParse(qrData.luxuryPercentage) ?? 0;

    qrData.luxuryAmount =
        // ((double.parse(qrData.netWeight) + double.parse(qrData.jarti)) *
        //         (luxuryPercentage / 100) *
        //         (stringToDouble(qrData.rate) / 11.664))
        //     .toStringAsFixed(3);
    qrData.luxuryAmount = ((double.parse(qrData.netWeight) + double.parse(qrData.jarti)) *(stringToDouble(qrData.rate) / 11.664))+ 
    (stringToDouble(qrData.jyala)) * (luxuryPercentage / 100);
    qrData.luxuryAmount = qrData.luxuryAmount.toStringAsFixed(3);
            
  }

void calcLuxuryCalculations(qrData) {
    //double stone1Price = stringToDouble(qrData.stone1Price ?? "0.000");
    //double stone2Price = stringToDouble(qrData.stone2Price ?? "0.000");
    //double stone3Price = stringToDouble(qrData.stone3Price ?? "0.000");

    double stone1Price= (qrData.newStone1Price.isNotEmpty && qrData.newStone1Price != "0.000")
      ? stringToDouble(qrData.newStone1Price)
      : stringToDouble(qrData.stone1Price ?? "0.000");
      double stone2Price= (qrData.newStone2Price.isNotEmpty && qrData.newStone2Price != "0.000")
      ? stringToDouble(qrData.newStone2Price)
      : stringToDouble(qrData.stone2Price ?? "0.000");
      double stone3Price= (qrData.newStone3Price.isNotEmpty && qrData.newStone3Price != "0.000")
      ? stringToDouble(qrData.newStone3Price)
      : stringToDouble(qrData.stone3Price ?? "0.000");
   
   double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
   double jartiGram = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
    double rate = stringToDouble(qrData.rate);

    
      // 🔥 CRITICAL: Use newJyala if available, otherwise fall back to original jyala
  double jyala = (qrData.newJyala.isNotEmpty && qrData.newJyala != "0.000")
      ? stringToDouble(qrData.newJyala)
      : stringToDouble(qrData.jyala);

  //  double jarti = (qrData.newjarti.isNotEmpty && qrData.newjarti != "0.000")
  //     ? stringToDouble(qrData.newjarti)
  //     : stringToDouble(qrData.jarti);

  print("🟢 Luxury Calculation - Using jyala: $jyala (newJyala: ${qrData.newJyala}, original jyala: ${qrData.jyala})");
  // print("🟢 Luxury Calculation - Using jarti: $jartiGram (newJarti: ${qrData.newjarti}, original jarti: ${qrData.jarti})");

  double nonTaxableAmount = (stone1Price + stone2Price + stone3Price);
  double baseAmount = qrData.jarti.trim().isEmpty
      ? (netWeight * (rate / 11.664)) + jyala + nonTaxableAmount
      : ((netWeight + jartiGram) * (rate / 11.664)) + jyala + nonTaxableAmount;

  double taxableAmount = baseAmount - nonTaxableAmount;
  if (taxableAmount < 0) taxableAmount = 0;
  double luxuryAmount = taxableAmount * 0.02;
  double total = baseAmount + luxuryAmount;

  qrData.baseAmount = baseAmount;
  qrData.nonTaxableAmount = nonTaxableAmount;
  qrData.taxableAmount = taxableAmount;
  qrData.luxuryAmount = luxuryAmount;
  qrData.total = total;

  print("🟢 Luxury Results - Base: $baseAmount, Taxable: $taxableAmount, Luxury: $luxuryAmount, Total: $total");
    

    
  }
  

 //-----------------------------------------------total expectedAmountDiscount--------------------------------------------
 void calcExpectedAmountDiscount(qrData, dynamic widget) {
  
  double expectedAmount = stringToDouble(qrData.expectedAmount);
  double total = stringToDouble(qrData.total);
   
   qrData.expectedAmountDiscount = total - expectedAmount;
   qrData.expectedAmountDiscount = qrData.expectedAmountDiscount.toStringAsFixed(3);
 }

 


  void calcRate(qrData, karatSettings) {
    var karat = karatSettings.where((karat) => karat["karat"] == qrData.purity);

    late double karatPercentage;
    if (karat.isEmpty) {
      var purityValue =
          double.tryParse(qrData.purity.replaceAll(RegExp(r'[Kk]'), '')) ?? 0;
      karatPercentage = (purityValue / 24) * 100;
    } else {
      karatPercentage = karat.first["percentage"];
      if (karatPercentage >= 99.5) {
        karatPercentage = 100;
      }
    }
    //for updating the bill
    if (qrData.rate.isNotEmpty) {
      return;
    }
    if ((qrData.metal.contains("Gold") || qrData.metal.contains("gold"))) {
      var newRatePerTola = double.parse(GetJewelleryRates.rates.gold);
      var ratePerTola = newRatePerTola +
          (prefs.containsKey("GoldSettings")
              ? double.parse(prefs.getString("GoldSettings") ?? "0.0")
              : 0.0);
      qrData.todayRate =
          qrData.rate = doubleToString((ratePerTola * karatPercentage / (100)));
    }
    if ((qrData.metal.contains("Silver") || qrData.metal.contains("silver"))) {
      var newRatePerTola = double.parse(GetJewelleryRates.rates.silver);
      var ratePerTola = newRatePerTola +
          (prefs.containsKey("SilverSettings")
              ? double.parse(prefs.getString("SilverSettings") ?? "0.0")
              : 0.0);
      qrData.todayRate = qrData.rate = doubleToString(ratePerTola);
    }
  }

  void calcPrice(qrData) {
  late double netWeight;
  if (qrData.netWeight.trim().isEmpty) {
    netWeight = 0;
  } else {
    netWeight = double.parse(qrData.netWeight);
  }
  
  // Use newJyala if available for price calculation
  double jyalaValue = (qrData.newJyala.isNotEmpty && qrData.newJyala != "0.000")
      ? stringToDouble(qrData.newJyala)
      : stringToDouble(qrData.jyala);

  if (qrData.jarti.trim().isEmpty) {
    qrData.price = doubleToString(
        (netWeight * (stringToDouble(qrData.rate) / 11.664)) +
            jyalaValue +
            stringToDouble(qrData.stone1Price ?? "0.000") +
            stringToDouble(qrData.stone2Price ?? "0.000") +
            stringToDouble(qrData.stone3Price ?? "0.000"));
    return;
  }
   if (qrData.netWeight.isEmpty) {
      qrData.price = doubleToString((double.parse(qrData.jarti) *
              (stringToDouble(qrData.rate) / 11.664)) +
          stringToDouble(qrData.jyala) +
          stringToDouble(qrData.stone1Price ?? "0.000") +
          stringToDouble(qrData.stone2Price ?? "0.000") +
          stringToDouble(qrData.stone3Price ?? "0.000"));
      
      return;
    }

    qrData.price = doubleToString(
        (((double.parse(qrData.netWeight) + double.parse(qrData.jarti)) *
                (stringToDouble(qrData.rate) / 11.664))) +
            stringToDouble(qrData.jyala) +
            stringToDouble(qrData.stone1Price ?? "0.000") +
            stringToDouble(qrData.stone2Price ?? "0.000") +
            stringToDouble(qrData.stone3Price ?? "0.000"));

  // ... rest of calcPrice function
}



//jyala and newJyala both get updated correctly in expected amount change but not updated in UI
//this should be working fine
 calcNewJyala( qrData) {

   // Don't touch jartiAmount or stones when discount applied to jyala
    qrData.newJartiAmount = qrData.jartiAmount;
    qrData.newStone1Price = qrData.stone1Price;
    qrData.newStone2Price = qrData.stone2Price;
    qrData.newStone3Price = qrData.stone3Price;

  double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount); 
  double jyala = stringToDouble(qrData.jyala); 
  if (expectedAmountDiscount <= jyala && expectedAmountDiscount > 0) { 
     double newJyala = (jyala - expectedAmountDiscount); 
    qrData.newJyala = newJyala.toStringAsFixed(3) ;

   
    qrData.discount = "applied_to_jyala";
    
  }else{
    qrData.newJyala = qrData.jyala;
  } 
//  qrData.jyala = jyala.toStringAsFixed(3) ;
    calcJyalaPercentage(qrData);   
}

  // void calcNewJartiAmount(qrData) {

  //   // Clear stone discounts when applying to jarti
  // qrData.newStone1Price = qrData.stone1Price;
  // qrData.newStone2Price = qrData.stone2Price;
  // qrData.newStone3Price = qrData.stone3Price;
   
  //   double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
  //   double rate = stringToDouble(qrData.rate);
  //   double jarti = stringToDouble(qrData.jarti);
  //   print("🟢 calcNewJartiAmount - jarti: $jarti, rate: $rate");
  //   double jartiAmount = (jarti * (rate / 11.664));
  //   //jartiAmount= qrData.jartiAmount;
  //   print("🟢 calcNewJartiAmount - calculated jartiAmount: $jartiAmount");

  //   double jyala = stringToDouble(qrData.jyala);

  //   if (expectedAmountDiscount > jyala && expectedAmountDiscount <= jartiAmount) {
  //     double newJartiAmount = jartiAmount - expectedAmountDiscount;
  //     qrData.newJartiAmount = newJartiAmount.toStringAsFixed(3);
  //      qrData.discount = "applied_to_jarti";

  //   // // Don't touch stones when discount applied to jartiAmount
  //   // qrData.newStone1Price = qrData.stone1Price;
  //   // qrData.newStone2Price = qrData.stone2Price;
  //   // qrData.newStone3Price = qrData.stone3Price;
  //   // qrData.discount = "applied_to_jarti";

  //   }else{
  //     qrData.newJartiAmount = qrData.jartiAmount;
  //   }

  //   calcJartiGram(qrData);
  //   calcJartiLal(qrData);
  //   calcJartiPercentage(qrData);
  //   //calcLuxuryCalculations(qrData);
  // }


void calcNewJartiAmount(qrData) {
  // Clear stone discounts when applying to jarti
  qrData.newStone1Price = qrData.stone1Price;
  qrData.newStone2Price = qrData.stone2Price;
  qrData.newStone3Price = qrData.stone3Price;
  
  double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
  double rate = stringToDouble(qrData.rate);
  double jarti = stringToDouble(qrData.jarti);
  print("🟢 calcNewJartiAmount - jarti: $jarti, rate: $rate");
  double jartiAmount = (jarti * (rate / 11.664));
  qrData.jartiAmount = jartiAmount.toStringAsFixed(3);// save jartiAmount in QrDataModel

  
  double jyala = stringToDouble(qrData.jyala);

  if (expectedAmountDiscount > jyala && expectedAmountDiscount <= jartiAmount) {
    double newJartiAmount = jartiAmount - expectedAmountDiscount;
    qrData.newJartiAmount = newJartiAmount.toStringAsFixed(3);
    qrData.discount = "applied_to_jarti";
    
    // 🔥 CRITICAL: Calculate newJarti from newJartiAmount and update main fields
    if (rate > 0) {
      double calculatedNewJarti = (newJartiAmount * 11.664) / rate;
      qrData.newJarti = calculatedNewJarti.toStringAsFixed(6);
      // Also update the main jarti field for UI display
      qrData.jarti = qrData.newJarti;
    }
  } else {
    qrData.newJartiAmount = qrData.jartiAmount;
    qrData.newJarti = qrData.jarti; // Keep same if no discount
  }

  // These functions should use the updated qrData.jarti (which now = newJarti)
  calcJartiGram(qrData);
  calcJartiLal(qrData);
  calcJartiPercentage(qrData);
}


 // Add this method in QrResultBloc class
void calcNewStonePrice(QrDataModel qrData) {
  double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
  double jartiAmount = stringToDouble(qrData.jartiAmount);
  
  // Only apply if discount > jartiAmount (and not applied to jyala)
  if (expectedAmountDiscount <= jartiAmount) {
    // Should have been applied to jartiAmount, not stones
    qrData.newStone1Price = qrData.stone1Price;
    qrData.newStone2Price = qrData.stone2Price;
    qrData.newStone3Price = qrData.stone3Price;
    qrData.discount = "should_be_jarti";
    return;
  }
  
  // Get stone prices
  double stone1Price = stringToDouble(qrData.stone1Price );
  qrData.stone1Price = stone1Price.toStringAsFixed(3);
  double stone2Price = stringToDouble(qrData.stone2Price );
  qrData.stone2Price = stone2Price.toStringAsFixed(3);
  double stone3Price = stringToDouble(qrData.stone3Price );
  qrData.stone3Price = stone3Price.toStringAsFixed(3);
  
  // Find the stone with highest price
  Map<String, dynamic> highestStone = {"name": "", "price": 0.0, "field": ""};
  
  if (stone1Price > highestStone["price"]) {
    highestStone = {"name": "stone1", "price": stone1Price, "field": "stone1Price"};
  }
  if (stone2Price > highestStone["price"]) {
    highestStone = {"name": "stone2", "price": stone2Price, "field": "stone2Price"};
  }
  if (stone3Price > highestStone["price"]) {
    highestStone = {"name": "stone3", "price": stone3Price, "field": "stone3Price"};
  }
  
  // Check if discount is greater than the highest stone price
  if (expectedAmountDiscount > highestStone["price"]) {
    // Discount cannot be given - show toast
    qrData.newStone1Price = qrData.stone1Price;
    qrData.newStone2Price = qrData.stone2Price;
    qrData.newStone3Price = qrData.stone3Price;
    qrData.discount = "cannot_give";
  } else {
    // Apply discount to the highest priced stone only
    double newStonePrice = highestStone["price"] - expectedAmountDiscount;
    
    // Update only the highest priced stone
    switch (highestStone["name"]) {
      case "stone1":
        qrData.newStone1Price = newStonePrice.toStringAsFixed(3);
        qrData.newStone2Price = qrData.stone2Price;
        qrData.newStone3Price = qrData.stone3Price;
        break;
      case "stone2":
        qrData.newStone2Price = newStonePrice.toStringAsFixed(3);
        qrData.newStone1Price = qrData.stone1Price;
        qrData.newStone3Price = qrData.stone3Price;
        break;
      case "stone3":
        qrData.newStone3Price = newStonePrice.toStringAsFixed(3);
        qrData.newStone1Price = qrData.stone1Price;
        qrData.newStone2Price = qrData.stone2Price;
        break;
    }
    qrData.discount = "applied_to_stone";
    calcLuxuryCalculations(qrData); // Recalculate luxury after stone price change
  }
}



void calcTotalFromExpectedAmount(QrDataModel qrData) {
  print("🟢 calcTotalFromExpectedAmount started");
  
  double expectedAmount = stringToDouble(qrData.expectedAmount);
  
  print("🟢 Target Expected Amount: $expectedAmount");
  
  // If no expected amount, use normal calculation
  if (expectedAmount == 0) {
    // Reset to original values
    qrData.newJyala = "";
    qrData.newJarti = "";
    qrData.newJartiAmount = "";
    qrData.jarti = qrData.jarti; // reset jarti to original
    calcLuxuryCalculations(qrData);
    return;
  }
  
  // Get original component values
  double stone1Price = stringToDouble(qrData.stone1Price);
  double stone2Price = stringToDouble(qrData.stone2Price);
  double stone3Price = stringToDouble(qrData.stone3Price);
  double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
  double originalJyala = stringToDouble(qrData.jyala);
  double originalJarti = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
  double rate = stringToDouble(qrData.rate);
  
  // Calculate fixed components
  double nonTaxableAmount = stone1Price + stone2Price + stone3Price;
  double originalJartiAmount = originalJarti * (rate / 11.664);
  double metalAmount = (netWeight + originalJarti) * (rate / 11.664);
  
  print("🟢 Original Components:");
  print("🟢   NonTaxable (Stones): $nonTaxableAmount");
  print("🟢   Metal Amount: $metalAmount");
  print("🟢   Original Jyala: $originalJyala, Original Jarti: $originalJarti");
  
  // Calculate required taxable amount:
  // total = 1.02 * taxableAmount + nonTaxableAmount
  // So: taxableAmount = (expectedAmount - nonTaxableAmount) / 1.02
  
  double requiredTaxableAmount = (expectedAmount - nonTaxableAmount) / 1.02;
  if (requiredTaxableAmount < 0) requiredTaxableAmount = 0;
  
  double originalTaxableAmount = metalAmount + originalJyala;
  double reductionNeeded = originalTaxableAmount - requiredTaxableAmount;
  
  print("🟢 Calculation:");
  print("🟢   Required Taxable Amount: $requiredTaxableAmount");
  print("🟢   Original Taxable Amount: $originalTaxableAmount");
  print("🟢   Reduction Needed: $reductionNeeded");
  
  // Initialize with original values
  double newJyala = originalJyala;
  double newJarti = originalJarti;
  double newJartiAmount = originalJartiAmount;
  
  // Apply reduction based on discount rules
  double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
  
  if (expectedAmountDiscount > 0) {
    // CASE 1: Discount <= Jyala → Reduce only from Jyala
    if (expectedAmountDiscount <= originalJyala) {
      newJyala = originalJyala - expectedAmountDiscount;
      // Jarti unchanged
      newJartiAmount = originalJartiAmount;
      
      print("🟢 CASE 1: Reduced from Jyala only");
      print("🟢   New Jyala: $newJyala (reduced by: $expectedAmountDiscount)");
    }
    // CASE 2: Discount > Jyala AND discount <= JartiAmount → Reduce from Jarti
    else if (expectedAmountDiscount <= originalJartiAmount) {
      // Jyala unchanged
      newJyala = originalJyala;
      
      // Calculate new jarti amount
      newJartiAmount = originalJartiAmount - expectedAmountDiscount;
      if (newJartiAmount < 0) newJartiAmount = 0;
      
      // Calculate new jarti from new jarti amount
      if (rate > 0) {
        newJarti = (newJartiAmount * 11.664) / rate;
      } else {
        newJarti = 0;
      }
      
      print("🟢 CASE 2: Reduced from Jarti only");
      print("🟢   New Jarti Amount: $newJartiAmount (reduced by: $expectedAmountDiscount)");
      print("🟢   New Jarti: $newJarti");
    }
    // CASE 3: Discount > JartiAmount → Try to reduce from stone (handled elsewhere)
    else {
      print("🟢 CASE 3: Discount exceeds jarti amount, should be handled by stone logic");
    }
  } else {
    print("🟢 No discount needed");
  }
  
  // Update the fields
  qrData.newJyala = newJyala.toStringAsFixed(3);
  qrData.newJarti = newJarti.toStringAsFixed(3);
  qrData.newJartiAmount = newJartiAmount.toStringAsFixed(3);
  
  print("🟢 Updated Fields:");
  print("🟢   newJyala: ${qrData.newJyala}");
  print("🟢   newJarti: ${qrData.newJarti}");
  print("🟢   newJartiAmount: ${qrData.newJartiAmount}");
  
  // Now recalculate luxury amounts with adjusted values
  calcLuxuryCalculations(qrData);
  
  // Verify the result
  double finalTotal = stringToDouble(qrData.price);
  double difference = (finalTotal - expectedAmount).abs();
  
  print("🟢 Final Results:");
  print("🟢   Expected: $expectedAmount, Calculated: $finalTotal");
  print("🟢   Difference: $difference");
  
  if (difference > 0.01) {
    print("🔴 WARNING: Total doesn't match expected amount! Difference: $difference");
  }
}

  QrResultBloc() : super(QrResultInitial()) {
    on<QrResultInitialEvent>((event, emit) async {
     
  
      var karatSettings = await db.rawQuery("SELECT * FROM KaratSettings");
      calcJartiLal(event.qrData);
      calcJartiPercentage(event.qrData);
      calcRate(event.qrData, karatSettings);
      calcJyalaPercentage(event.qrData);//
      calcPrice(event.qrData);
      //calcTotal( event.qrData);//
      calcLuxuryCalculations(event.qrData);//
      //calcExpectedAmount(event.qrData);//
      
      

      emit(
        QrResultInitialState(
          qrData: event.qrData,
          isUpdate: event.isUpdate,
          originalQrData: QrDataModel(
            id: event.qrData.id,
            code: event.qrData.code,
            item: event.qrData.item,
            itemId: event.qrData.itemId,
            materialId: event.qrData.materialId,
            pcs: event.qrData.pcs,
            metal: event.qrData.metal,
            grossWeight: event.qrData.grossWeight,
            netWeight: event.qrData.netWeight,
            purity: event.qrData.purity,
            jarti: event.qrData.jarti,
            
            jartiLal: event.qrData.jartiLal,
            jartiPercentage: event.qrData.jartiPercentage,
            jyala: event.qrData.jyala,
            jyalaPercentage: event.qrData.jyalaPercentage,
            mrp: event.qrData.mrp,
            price: event.qrData.price,
            todayRate: event.qrData.todayRate,
            rate: event.qrData.rate,
            stone1Name: event.qrData.stone1Name,
            stone1Id: event.qrData.stone1Id,
            stone1Weight: event.qrData.stone1Weight,
            stone1Price: event.qrData.stone1Price,
            stone2Name: event.qrData.stone2Name,
            stone2Id: event.qrData.stone2Id,
            stone2Weight: event.qrData.stone2Weight,
            stone2Price: event.qrData.stone2Price,
            stone3Name: event.qrData.stone3Name,
            stone3Id: event.qrData.stone3Id,
            stone3Weight: event.qrData.stone3Weight,
            stone3Price: event.qrData.stone3Price,
            baseAmount: event.qrData.baseAmount,
            nonTaxableAmount: event.qrData.nonTaxableAmount,
            taxableAmount: event.qrData.taxableAmount,
            luxuryAmount: event.qrData.luxuryAmount,
            total: event.qrData.total,
            expectedAmount: event.qrData.expectedAmount,
            expectedAmountDiscount: event.qrData.expectedAmountDiscount,
            discount: event.qrData.discount,

             jartiAmount: event.qrData.jartiAmount,
            // netWeightAmount: event.qrData.netWeightAmount,
            // stoneTotalPrice: event.qrData.stoneTotalPrice,

            newJyala: event.qrData.newJyala,
            newJyalaPercentage: event.qrData.newJyalaPercentage,
            newJartiAmount: event.qrData.newJartiAmount,
            newJarti: event.qrData.newJarti,
            newJartiLal: event.qrData.newJartiLal,
            newJartiPercentage: event.qrData.newJartiPercentage,
            newStone1Price: event.qrData.newStone1Price,
            newStone2Price: event.qrData.newStone2Price,
            newStone3Price: event.qrData.newStone3Price,
            newStoneTotalPrice: event.qrData.newStoneTotalPrice,
          ),
        ),
      );
    });
    on<QrResultJyalaChangedEvent>((event, emit) {
      print("🟢 QrResultJyalaChangedEvent triggered");
  print("🟢 jyala value: ${event.qrData.jyala}");
  print("🟢 newJyala value: ${event.qrData.newJyala}");

       event.qrData.newJyala = "";
  event.qrData.newJyalaPercentage = "";
  
      calcJyalaPercentage(event.qrData);
        print("🟢 Calculated jyalaPercentage: ${event.qrData.jyalaPercentage}");
      //calcTotal(event.qrData);
     calcLuxuryCalculations(event.qrData);
   
     

      emit(QrResultPriceChangedState(qrData: event.qrData));
    });
    on<QrResultJyalaPercentageChangedEvent>((event, emit) {
  
  // Clear any discount calculations when manually editing
  event.qrData.newJyala = "";
  event.qrData.newJyalaPercentage = "";
      calcJyala(event.qrData);
      //calcTotal(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });

    on<QrResultNetWeightChangedEvent>((event, emit) {
      calcJartiPercentage(event.qrData);
      calcJyalaPercentage(event.qrData);
      //calcTotal(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });

    on<QrResultRateChangedEvent>((event, emit) {
       calcJyala(event.qrData);
      calcJyalaPercentage(event.qrData);
      //calcTotal(event.qrData);
      calcLuxuryCalculations(event.qrData);
     
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });




    on<QrResultJartiLalChangedEvent>((event, emit) {
      if (event.qrData.jartiLal.isEmpty) {
        event.qrData.jarti = "0.0";
      } else {
        event.qrData.jarti =
            (double.parse(event.qrData.jartiLal) * (11.664 / 100))
                .toStringAsFixed(3);
      }
      calcJartiPercentage(event.qrData);
      calcJyalaPercentage(event.qrData);
      calcJartiGram(event.qrData);
      //calcTotal(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });


    on<QrResultJartiGramChangedEvent>((event, emit) {
      calcJartiPercentage(event.qrData);
      calcJartiLal(event.qrData);
      calcJyalaPercentage(event.qrData);
      //calcTotal(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });

    on<QrResultJartiPercentageChangedEvent>((event, emit) {
      calcJartiGram(event.qrData);
      calcJartiLal(event.qrData);
      calcJyalaPercentage(event.qrData);
      //calcTotal(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });


on<QrResultExpectedAmountChangedEvent>((event, emit) {
  print("🟢 QrResultExpectedAmountChangedEvent triggered");
  //calcjartiAmount(event.qrData);//



  double expectedAmountDiscount = stringToDouble(event.qrData.expectedAmountDiscount);
  double jarti = stringToDouble(event.qrData.jarti);
  double rate = stringToDouble(event.qrData.rate);
 
  double jartiAmount = jarti * (rate / 11.664);
  
  double jyala = stringToDouble(event.qrData.jyala);
  
  
  
  // Reset new fields
  event.qrData.newJyala = "";
  event.qrData.newJarti = "";
  event.qrData.newJartiAmount = "";
  event.qrData.newJartiLal = "";
  event.qrData.newJartiPercentage = "";
  
  if (expectedAmountDiscount > 0 && expectedAmountDiscount <= jyala) {
    // Apply to Jyala
    calcNewJyala(event.qrData);
    print("🟢 Applied to Jyala - newJyala: ${event.qrData.newJyala}");
  } else if (expectedAmountDiscount > jyala && expectedAmountDiscount <= jartiAmount) {
    // Apply to Jarti
    print("🟢 Applying discount to Jarti");
    
    calcNewJartiAmount(event.qrData);
    print("🟢 Applied to Jarti - newJarti: ${event.qrData.newJarti}, newJartiAmount: ${event.qrData.newJartiAmount}");
  } else {
    // Apply to Stone (if needed)
    calcNewStonePrice(event.qrData);
  }

  
  // 🔥 CRITICAL: Always recalculate luxury after any discount
  calcLuxuryCalculations(event.qrData);
  print("🟢 After luxury calc - total: ${event.qrData.total}");
  
  emit(QrResultExpectedAmountDiscountChangedState(
    qrData: event.qrData, 
    isUpdate: isUpdate, 
    originalQrData: originalQrData
  ));
});

  // on<QrResultExpectedAmountChangedEvent>((event, emit) {
  //   calcTotalFromExpectedAmount(event.qrData);

  //   emit(QrResultExpectedAmountDiscountChangedState(
  //   qrData: event.qrData, 
  //   isUpdate: isUpdate, 
  //   originalQrData: originalQrData
  // ));
  // });
 


    on<QrResultExpectedAmountDiscountChangedEvent>((event, emit) {
      //calcTotalFromExpectedAmount(event.qrData);
      calcJartiLal(event.qrData);
      calcJartiPercentage(event.qrData);
      calcJyalaPercentage(event.qrData);
      
      //calcJyala(event.qrData);
      //calcTotal(event.qrData);
      calcLuxuryCalculations(event.qrData);
  emit(QrResultTotalChangedState(qrData: event.qrData));
});

    on<QrResultItemChangedEvent>(
      (event, emit) {
        emit(QrResultPriceChangedState(qrData: event.qrData));
      },
    );

    on<QrResultOnLoadingEvent>((event, emit) {
      emit(QrResultOnLoadingState(isLoading: event.isLoading));
    });


  }
  
  get qrData => null;
}










