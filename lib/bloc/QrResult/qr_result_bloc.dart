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

    // if (rate == 0) {
    //   qrData.baseAmount = 0;
    //   qrData.nonTaxableAmount = 0;
    //   qrData.taxableAmount = 0;
    //   qrData.luxuryAmount = 0;
    //   qrData.total = 0;
    //   return;
    // }
    // else if (jyala < 0) {
    //   jyala = 0;
    // }


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
  
   //--------------------------------------------------------------------------------------------------

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
      calcJyalaPercentage(event.qrData);
      calcPrice(event.qrData);
      calcLuxuryCalculations(event.qrData);//

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
          ),
        ),
      );
    });
    on<QrResultJyalaChangedEvent>((event, emit) {
      calcJyalaPercentage(event.qrData);
      calcPrice(event.qrData);
     calcLuxuryCalculations(event.qrData);

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
