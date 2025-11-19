import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import '../../data/query/get_jewellery_rates.dart';
import '../../main_common.dart';
import '../../models/qr_data_model.dart';

part 'qr_result_event.dart';
part 'qr_result_state.dart';

class QrResultBloc extends Bloc<QrResultEvent, QrResultState> {
  
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

  void calcJyalaPercentage(qrData) {
    final double jyala = stringToDouble(qrData.jyala);
    final double rate = stringToDouble(qrData.rate);
    late double jarti;
    late double netWeight;
    if (qrData.jarti.trim().isEmpty) {
      jarti = 0;
    } else {
      jarti = double.parse(qrData.jarti);
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
    qrData.jyalaPercentage =
        (((jyala * 100) / ((rate / 11.664) * (netWeight + jarti))))
            .toStringAsFixed(2);
    if (qrData.jyalaPercentage == "NaN") {
      qrData.jyalaPercentage = "0.000";
    }
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

  void calcJartiGram(qrData) {
    if (qrData.jartiPercentage.trim().isEmpty ||
        qrData.jartiPercentage == "0.000") {
      qrData.jarti = "0.000";
      return;
    }

    qrData.jarti = ((double.parse(qrData.jartiPercentage) / 100) *
            double.parse(qrData.netWeight))
        .toStringAsFixed(3);
  }

  

  //---------------------------------------luxury calculation-----------------------------------------------------------

  void calcLuxury(qrData) {
    double luxuryPercentage = double.tryParse(qrData.luxuryPercentage) ?? 0;

    qrData.luxuryAmount =
        ((double.parse(qrData.netWeight) + double.parse(qrData.jarti)) *
                (luxuryPercentage / 100) *
                (stringToDouble(qrData.rate) / 11.664))
            .toStringAsFixed(3);
  }

void calcLuxuryCalculations(qrData) {
    double stone1Price = stringToDouble(qrData.stone1Price ?? "0.000");
   double stone2Price = stringToDouble(qrData.stone2Price ?? "0.000");
    double stone3Price = stringToDouble(qrData.stone3Price ?? "0.000");
   double netWeight = qrData.netWeight.trim().isEmpty ? 0 : double.parse(qrData.netWeight);
   double jartiGram = qrData.jarti.trim().isEmpty ? 0 : double.parse(qrData.jarti);
    double rate = stringToDouble(qrData.rate);
    double jyala = stringToDouble(qrData.jyala);

   


   double nonTaxableAmount = stone1Price + stone2Price + stone3Price;
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
  }
  
  //------------------------------------expected amount--------------------------------------------------------------
  void calcExpectedAmount(qrData) {
    double expectedAmount = stringToDouble(qrData.expectedAmount);
    double total = qrData.total;

    if (expectedAmount > 0 && expectedAmount < total) {
      qrData.total = expectedAmount;
    } else {
      qrData.total = total;
    }
  }
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


void calcTotalFromExpectedAmount(qrData) {
  // 1️⃣ Parse expected amount
  double expectedAmount = stringToDouble(qrData.expectedAmount);
  if (expectedAmount == 0) {
    calcLuxuryCalculations(qrData);
    return;
  }

  // 2️⃣ Parse expectedAmountDiscount
  double expectedAmountDiscount =
      stringToDouble(qrData.expectedAmountDiscount);

  // 3️⃣ Parse component values
  double stone1Price = stringToDouble(qrData.stone1Price);
  double stone2Price = stringToDouble(qrData.stone2Price);
  double stone3Price = stringToDouble(qrData.stone3Price);
  double netWeight = qrData.netWeight.trim().isEmpty
      ? 0
      : double.parse(qrData.netWeight);
  double jartiGram = qrData.jarti.trim().isEmpty
      ? 0
      : double.parse(qrData.jarti);
  double jyala = stringToDouble(qrData.jyala);
  double rate = stringToDouble(qrData.rate);

  double jartiAmount = jartiGram * (rate / 11.664);

  // 4️⃣ Copy components into local variables
  double netWeightAmount = netWeight * (rate / 11.664);
  double jyalaAmt = jyala;
  double jartiAmt = jartiAmount;
  double stone1 = stone1Price;
  double stone2 = stone2Price;
  double stone3 = stone3Price;
  // ignore: unused_local_variable
  double stoneTotal = stone1 + stone2 + stone3;

  // 5️⃣ Apply ExpectedAmountDiscount based on flow diagram
  if (expectedAmountDiscount <= jyalaAmt) {
    // Reduce Jyala only
    jyalaAmt -= expectedAmountDiscount;
    jyala = jyalaAmt;
  } else if (expectedAmountDiscount > jyalaAmt && expectedAmountDiscount <= jartiAmt) {
    // Reduce Jarti only
    jartiAmt -= expectedAmountDiscount;
    jartiAmount = jartiAmt;
  } else if (expectedAmountDiscount > jartiAmt) {
    // Reduce Stones only
    // if (stoneTotal > 0) {
    //   double ratio = expectedAmountDiscount / stoneTotal;
    //   stone1 *= (1 - ratio);
    //   stone2 *= (1 - ratio);
    //   stone3 *= (1 - ratio);
    // }
    stoneTotal -= expectedAmountDiscount;
  }

  // 6️⃣ Recalculate taxable amount (Jyala + Jarti + NetWeight)
  double taxableAmount = netWeightAmount + jartiAmt + jyalaAmt;
  double nonTaxableAmount = stone1 + stone2 + stone3;
  double baseAmount = taxableAmount + nonTaxableAmount;

  // 7️⃣ Apply luxury tax (2%) on taxable amount
  double luxuryAmount = taxableAmount * 0.02;

  // 8️⃣ Compute total
  // ignore: unused_local_variable
  double total = baseAmount + luxuryAmount;
  

  // 9️⃣ Save updated amounts back to qrData
  qrData.jyala = jyalaAmt.toStringAsFixed(3);
  qrData.jarti = jartiAmt.toStringAsFixed(3);
  qrData.stone1Price = stone1.toStringAsFixed(3);
  qrData.stone2Price = stone2.toStringAsFixed(3);
  qrData.stone3Price = stone3.toStringAsFixed(3);

  // 1️⃣0️⃣ Recalculate totals
  calcLuxuryCalculations(qrData);
}







 //-----------------------------------------------total expectedAmountDiscount--------------------------------------------
 void calcExpectedAmountDiscount(qrData) {
   double expectedAmount = stringToDouble(qrData.expectedAmount);
   double total = qrData.total;
   //double expectedAmountDiscount = stringToDouble(qrData.expectedAmountDiscount ?? "0.000");

   // ignore: unused_local_variable
   double expectedAmountDiscount = total - expectedAmount;
 }

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
    if (qrData.jarti.trim().isEmpty) {
      qrData.price = doubleToString(
          (netWeight * (stringToDouble(qrData.rate) / 11.664)) +
              stringToDouble(qrData.jyala) +
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
    
  }

  QrResultBloc() : super(QrResultInitial()) {
    on<QrResultInitialEvent>((event, emit) async {
      var karatSettings = await db.rawQuery("SELECT * FROM KaratSettings");
      calcJartiLal(event.qrData);
      calcJartiPercentage(event.qrData);
      calcRate(event.qrData, karatSettings);
      calcJyalaPercentage(event.qrData);//
      calcPrice(event.qrData);
      //calcTotal( event.qrData);
      calcLuxuryCalculations(event.qrData);//
      calcExpectedAmount(event.qrData);
      

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
            //jartiAmount: event.qrData.jartiAmount,
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
          ),
        ),
      );
    });
    on<QrResultJyalaChangedEvent>((event, emit) {
      calcJyalaPercentage(event.qrData);
      calcPrice(event.qrData);
     calcLuxuryCalculations(event.qrData);
     //calcTaxableAmount(event.qrData);
     

      emit(QrResultPriceChangedState(qrData: event.qrData));
    });
    on<QrResultJyalaPercentageChangedEvent>((event, emit) {
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
      // calcJyala(event.qrData);
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
      event.qrData.expectedAmount = event.qrData.expectedAmount; // Already set in qr_result.dart
      calcTotalFromExpectedAmount(event.qrData);
      calcJyala(event.qrData);
      calcLuxuryCalculations(event.qrData);
      calcExpectedAmountDiscount(event.qrData);
      emit(QrResultPriceChangedState(qrData: event.qrData));
    });

    on<QrResultExpectedAmountDiscountChangedEvent>((event, emit) {
      calcTotalFromExpectedAmount(event.qrData);
      calcJyala(event.qrData);
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
}

class QrResultTotalChangedState extends QrResultState {
  final QrDataModel qrData;
  QrResultTotalChangedState({required this.qrData});
}





// class QrResultExpectedAmountChangedEvent extends QrResultEvent {
//  final QrDataModel qrData;
//  QrResultExpectedAmountChangedEvent({required this.qrData});
// }


