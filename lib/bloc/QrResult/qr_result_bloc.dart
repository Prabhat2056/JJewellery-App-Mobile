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

 
  // void calcJyalaPercentage(qrData) {
    
  //   final double jyala = stringToDouble(qrData.jyala);
  //   final double rate = stringToDouble(qrData.rate);
  //   late double jarti;
  //   late double netWeight;
  //   if (qrData.jarti.trim().isEmpty) {
  //     jarti = 0;
  //   } else {
  //     jarti = double.parse(qrData.jarti);
  //   }
  //   if (qrData.netWeight.trim().isEmpty) {
  //     netWeight = 0;
  //   } else {
  //     netWeight = double.parse(qrData.netWeight);
  //   }
  //   if (netWeight == 0 && jarti == 0) {
  //     qrData.jyalaPercentage = "0.000";
  //     return;
  //   }
  //   qrData.jyalaPercentage =
  //       (((jyala * 100) / ((rate / 11.664) * (netWeight + jarti))))
  //           .toStringAsFixed(2);
  //   if (qrData.jyalaPercentage == "NaN") {
  //     qrData.jyalaPercentage = "0.000";
  //   }
  // }

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

  // void calcJartiGram(qrData) {
  //   if (qrData.jartiPercentage.trim().isEmpty ||
  //       qrData.jartiPercentage == "0.000") {
  //     qrData.jarti = "0.000";
  //     return;
  //   }

  //   qrData.jarti = ((double.parse(qrData.jartiPercentage) / 100) *
  //           double.parse(qrData.netWeight))
  //       .toStringAsFixed(3);
  // }

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
      qrData.newJarti = jarti.toStringAsFixed(3);
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
    if (qrData.netWeight.trim().isEmpty ||
        qrData.netWeight == "0" ||
        qrData.jarti.trim().isEmpty ||
        double.parse(qrData.jarti) == 0) {
      qrData.jartiLal = "0.0";
      return;
    }

    qrData.jartiLal =
        (double.parse(qrData.jarti) * (100 / 11.664)).toStringAsFixed(3);
  }

  

  // void calcjartiAmount(qrData){
  //      if (qrData.jarti.trim().isEmpty ||
  //       qrData.jarti == "0" ||
  //       qrData.rate.trim().isEmpty) {
  //     qrData.jartiAmount = "0.000";
  //     return;
  //  }

  //   try {
  //     final double jarti = double.parse(qrData.jarti);
  //     final double rate = double.parse(qrData.rate);
  //     qrData.jartiAmount = (jarti * (rate / 11.664)).toStringAsFixed(3);
  //  } catch (e) {
  //    qrData.jartiAmount = "0.000";
  //   }
  // }
  

  

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
    double stone1Price = stringToDouble(qrData.stone1Price ?? "0.000");
   double stone2Price = stringToDouble(qrData.stone2Price ?? "0.000");
    double stone3Price = stringToDouble(qrData.stone3Price ?? "0.000");
   double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
   double jartiGram = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
    double rate = stringToDouble(qrData.rate);

    
      // 🔥 CRITICAL: Use newJyala if available, otherwise fall back to original jyala
  double jyala = (qrData.newJyala.isNotEmpty && qrData.newJyala != "0.000")
      ? stringToDouble(qrData.newJyala)
      : stringToDouble(qrData.jyala);

  print("🟢 Luxury Calculation - Using jyala: $jyala (newJyala: ${qrData.newJyala}, original jyala: ${qrData.jyala})");

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
  
   
  //  double expectedAmount= double.tryParse(widget.controller.text.trim())?.toDouble() ?? 0.0;
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


//  void calcnewJyalaPercentage(qrData) {
//     final double newJyala = stringToDouble(qrData.newJyala);
//     final double rate = stringToDouble(qrData.rate);
//     late double jarti;
//     late double netWeight;
//     if (qrData.jarti.trim().isEmpty) {
//       jarti = 0;
//     } else {
//       jarti = double.parse(qrData.jarti);
//     }
//     if (qrData.netWeight.trim().isEmpty) {
//       netWeight = 0;
//     } else {
//       netWeight = double.parse(qrData.netWeight);
//     }
//     if (netWeight == 0 && jarti == 0) {
//       qrData.newJyalaPercentage = "0.000";
//       return;
//     }
//     qrData.newJyalaPercentage =
//         (((newJyala * 100) / ((rate / 11.664) * (netWeight + jarti))))
//             .toStringAsFixed(2);
//     if (qrData.newJyalaPercentage == "NaN") {
//       qrData.newJyalaPercentage = "0.000";
//     }
//   }

//jyala and newJyala both get updated correctly in expected amount change but not updated in UI
//this should be working fine
 calcNewJyala( qrData) { 
  double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount); 
  double jyala = stringToDouble(qrData.jyala); 
  if (expectedAmountDiscount <= jyala) { 
     double newJyala = (jyala - expectedAmountDiscount); 
    qrData.newJyala = newJyala.toStringAsFixed(3) ;
    
  }else{
    qrData.newJyala = qrData.jyala;
  } 
//  qrData.jyala = jyala.toStringAsFixed(3) ;
    calcJyalaPercentage(qrData);   
}

  void calcNewJartiAmount(qrData) {
    //qrData.newJartiAmount = qrData.jartiAmount;
    double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount);
    double rate = stringToDouble(qrData.rate);
    double jarti = stringToDouble(qrData.jarti);
    double jartiAmount = (jarti * (rate / 11.664));
     //jartiAmount = (qrData.jartiAmount).toStringAsFixed(3);
    double jyala = stringToDouble(qrData.jyala);

    if (expectedAmountDiscount > jyala) {
      double newJartiAmount = jartiAmount - expectedAmountDiscount;
      qrData.newJartiAmount = newJartiAmount.toStringAsFixed(3);
    }else{
      qrData.newJartiAmount = qrData.jartiAmount;
    }

    calcJartiGram(qrData);
    calcJartiLal(qrData);
    calcJartiPercentage(qrData);
  }

  QrResultBloc() : super(QrResultInitial()) {
    on<QrResultInitialEvent>((event, emit) async {
     
  
      var karatSettings = await db.rawQuery("SELECT * FROM KaratSettings");
      calcJartiLal(event.qrData);
      calcJartiPercentage(event.qrData);
      calcRate(event.qrData, karatSettings);
      calcJyalaPercentage(event.qrData);//
      calcPrice(event.qrData);
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

             //jartiAmount: event.qrData.jartiAmount,
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
      calcPrice(event.qrData);
     calcLuxuryCalculations(event.qrData);
     //calcTaxableAmount(event.qrData);
     

      emit(QrResultPriceChangedState(qrData: event.qrData));
    });
    on<QrResultJyalaPercentageChangedEvent>((event, emit) {

      print("🟢 QrResultJyalaPercentageChangedEvent triggered");
  print("🟢 Manual jyalaPercentage value: ${event.qrData.jyalaPercentage}");
  
  // Clear any discount calculations when manually editing
  event.qrData.newJyala = "";
  event.qrData.newJyalaPercentage = "";
      calcJyala(event.qrData);
      calcPrice(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });
    on<QrResultNetWeightChangedEvent>((event, emit) {
      calcJartiPercentage(event.qrData);
      calcJyalaPercentage(event.qrData);
      calcPrice(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });
    on<QrResultRateChangedEvent>((event, emit) {
       calcJyala(event.qrData);
      calcJyalaPercentage(event.qrData);
      calcPrice(event.qrData);
      calcLuxuryCalculations(event.qrData);
      

      emit(QrResultPriceChangedState(qrData: event.qrData));
    });
    on<QrResultJartiGramChangedEvent>((event, emit) {
      calcJartiPercentage(event.qrData);
      calcJartiLal(event.qrData);
      calcJyalaPercentage(event.qrData);
      calcPrice(event.qrData);
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
      calcPrice(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });
    on<QrResultJartiPercentageChangedEvent>((event, emit) {
      calcJartiGram(event.qrData);
      calcJartiLal(event.qrData);
      calcJyalaPercentage(event.qrData);
      calcPrice(event.qrData);
      calcLuxuryCalculations(event.qrData);
      
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });

    on<QrResultExpectedAmountChangedEvent>((event, emit) {
       print("🟢 QrResultExpectedAmountChangedEvent - Before calculations");
  print("🟢 jyala: ${event.qrData.jyala}, newJyala: ${event.qrData.newJyala}");
      calcNewJyala(event.qrData);
      calcNewJartiAmount(event.qrData);
      print("🟢 After new calculations - jyala: ${event.qrData.jyala}, newJyala: ${event.qrData.newJyala}");
      calcLuxuryCalculations(event.qrData);
      print("🟢 After luxury calc - total: ${event.qrData.total}, luxury: ${event.qrData.luxuryAmount}");
      
      //emit(QrResultExpectedAmountDiscountChangedState(qrData: event.qrData));
      emit(QrResultExpectedAmountDiscountChangedState(qrData: event.qrData, isUpdate: isUpdate, originalQrData: originalQrData));
    });




    on<QrResultExpectedAmountDiscountChangedEvent>((event, emit) {
      //calcTotalFromExpectedAmount(event.qrData);
      calcJartiLal(event.qrData);
      calcJartiPercentage(event.qrData);
      calcJyalaPercentage(event.qrData);
      
      //calcJyala(event.qrData);
      calcPrice(event.qrData);
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
//   calcPrice(resetData);
//   calcLuxuryCalculations(resetData);

//   emit(QrResultResetToOriginalState(
//     qrData: resetData,
//     isUpdate: isUpdate,
//     originalQrData: originalQrData,
//   ));
// });
  }
  
  get qrData => null;
}




// class QrResultTotalChangedState extends QrResultState {
//   final QrDataModel qrData;
//   QrResultTotalChangedState({required this.qrData});
// }





