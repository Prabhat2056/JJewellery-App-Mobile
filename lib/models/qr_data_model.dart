class QrDataModel {
  String id;
  String code;
  String item;
  int itemId;
  int materialId;
  int pcs;
  String metal;
  String grossWeight;
  String netWeight;
  String purity;
  String jarti;
  String jartiLal;
  String jartiPercentage;
  String jyala;
  String jyalaPercentage;
  String mrp;
  String price;
  String todayRate;
  String rate;
  String stone1Name;
  int stone1Id;
  String stone1Weight;
  String stone1Price;
  String stone2Name;
  int stone2Id;
  String stone2Weight;
  String stone2Price;
  String stone3Name;
  int stone3Id;
  String stone3Weight;
  String stone3Price;
  double baseAmount;
double nonTaxableAmount;
double taxableAmount;
double luxuryAmount;
double total; // total
String expectedAmount = "";
String discount = "";//
String expectedAmountDiscount = ""; // ⭐ NEW FIELD

// String netWeightAmount ="";
  String jartiAmount= "";
//   String stoneTotalPrice= "";

String newJyala;//
String newJyalaPercentage;//
String newJarti;//
String newJartiPercentage;//
String newJartiLal;//
String newJartiAmount;
String newStone1Price;
String newStone2Price;
String newStone3Price;
String newStoneTotalPrice;



  QrDataModel({
    required this.id,
    required this.code,
    required this.item,
    required this.itemId,
    required this.materialId,
    required this.pcs,
    required this.metal,
    required this.grossWeight,
    required this.netWeight,
    required this.purity,
    required this.jarti,
  //required this.jartiAmount,
    required this.jartiLal,
    required this.jartiPercentage,
    required this.jyala,
    required this.jyalaPercentage,
    required this.mrp,
    required this.price,
    required this.todayRate,
    required this.rate,
    required this.stone1Name,
    required this.stone1Id,
    required this.stone1Weight,
    required this.stone1Price,
    required this.stone2Name,
    required this.stone2Id,
    required this.stone2Weight,
    required this.stone2Price,
    required this.stone3Name,
    required this.stone3Id,
    required this.stone3Weight,
    required this.stone3Price,
    required this.baseAmount ,
    required this.nonTaxableAmount ,
    required this.taxableAmount ,
    required this.luxuryAmount ,
    required this.total ,
    required this.expectedAmount ,
    required this.discount ,
    required this.expectedAmountDiscount ,

    // required this.netWeightAmount,
    required this.jartiAmount,
    // required this.stoneTotalPrice,

    required this.newJyala,//
    required this.newJyalaPercentage,//
    required this.newJarti,//
    required this.newJartiPercentage,//
    required this.newJartiLal,//
    required this.newJartiAmount,
    required this.newStone1Price,
    required this.newStone2Price,
    required this.newStone3Price,
    required this.newStoneTotalPrice, 
  });


  Map<String, dynamic> toJson() => {
        'id': "0",
        'billId': 0,
        'itemId': itemId,
        'materialId': materialId,
        'pcs': pcs,
        'rate': rate.replaceAll(',', '').trim(),
        'amount': price.replaceAll(',', '').trim(),
        'jartiQty': jarti,
        'jartiLal': jartiLal,
        //'jartiAmount': jartiAmount.replaceAll(',', '').trim(),
        'jartiPercent': jartiPercentage,
        'jyala': jyala.replaceAll(',', '').trim(),
        //'luxuryPercent': luxuryPercentage,//
        'luxuryAmount': luxuryAmount.toStringAsFixed(2),
        'baseAmount': baseAmount.toStringAsFixed(2),
        'nonTaxableAmount': nonTaxableAmount.toStringAsFixed(2),
        'taxableAmount': taxableAmount.toStringAsFixed(2),
        'totalAmount': total.toStringAsFixed(2),
        'expectedAmount': expectedAmount.replaceAll(',', '').trim(),
        'discount': discount,//
        'expectedAmountDiscount': expectedAmountDiscount,
        'jartiAmount': jartiAmount,

         //'jartiAmount': jartiAmount.replaceAll(',', '').trim(),
        // 'netWeightAmount': netWeightAmount.replaceAll(',', '').trim(),
        // 'stoneTotalPrice': stoneTotalPrice.replaceAll(',', '').trim(),

        'stone1Id': stone1Id,
        'stone1Qty': stone1Id == 0
            ? 0
            : (stone1Weight.contains("/") ? stone1Weight.split('/')[0] : 0),
        'stone1Caret': stone1Id == 0
            ? 0
            : (stone1Weight.contains("/")
                ? stone1Weight.split('/')[1]
                : stone1Weight),
        'stone1Amount':
            stone1Id == 0 ? 0 : stone1Price.replaceAll(',', '').trim(),
        'stone2Id': stone2Id,
        'stone2Qty': stone2Id == 0
            ? 0
            : (stone2Weight.contains("/") ? stone2Weight.split('/')[0] : 0),
        'stone2Caret': stone2Id == 0
            ? 0
            : (stone2Weight.contains("/")
                ? stone2Weight.split('/')[1]
                : stone2Weight),
        'stone2Amount':
            stone2Id == 0 ? 0 : stone2Price.replaceAll(',', '').trim(),
        'stone3Id': stone3Id,
        'stone3Qty': stone2Id == 0
            ? 0
            : (stone3Weight.contains("/") ? stone3Weight.split('/')[0] : 0),
        'stone3Caret': stone3Id == 0
            ? 0
            : (stone3Weight.contains("/")
                ? stone3Weight.split('/')[1]
                : stone3Weight),
        'stone3Amount':
            stone3Id == 0 ? 0 : stone3Price.replaceAll(',', '').trim(),
        'code': code,
        'grossWt': grossWeight,
        'netWt': netWeight,
        'mrp': mrp.replaceAll(",", ''),
        'purity': purity.replaceAll(RegExp(r'[Kk]'), ''),

        //updated price
        'newJyala': newJyala,//
        'newJyalaPercentage': newJyalaPercentage,//
        'newJarti': newJarti,//
        'newJartiPercentage': newJartiPercentage,//
        'newJartiLal': newJartiLal,//
        'newJartiAmount': newJartiAmount,//
        'newStone1Price': newStone1Price,
        'newStone2Price': newStone2Price,
        'newStone3Price': newStone3Price,
        'newStoneTotalPrice': newStoneTotalPrice,
      };

  QrDataModel copyWith({
    String? id,
    String? code,
    String? item,
    int? itemId,
    int? materialId,
    int? pcs,
    String? metal,
    String? grossWeight,
    String? netWeight,
    String? purity,
    String? jarti,
    String? jartiPercentage,
    String? jartiLal,
      //String? jartiAmount,
    String? jyala,
    String? jyalaPercentage,
    String? mrp,
    
    String? price,
    String? todayRate,
    String? rate,
    String? stone1Name,
    int? stone1Id,
    String? stone1Weight,
    String? stone1Price,
    String? stone2Name,
    int? stone2Id,
    String? stone2Weight,
    String? stone2Price,
    String? stone3Name,
    int? stone3Id,
    String? stone3Weight,
    String? stone3Price,
    double? baseAmount,
    double? nonTaxableAmount,
    double? taxableAmount,
    double? luxuryAmount,
    double? total,
    String? expectedAmount,
    String? discount,
    String? expectedAmountDiscount,

    // String? netWeightAmount,
     String? jartiAmount,
    // String? stoneTotalPrice,

    String? newJyala,//
    String? newJyalaPercentage,//
    String? newJarti,//
    String? newJartiPercentage,//
    String? newJartiLal,//
    String? newJartiAmount,
    String? newStone1Price,
    String? newStone2Price,
    String? newStone3Price,
    String? newStoneTotalPrice,
  
    
    }) {
    return QrDataModel(
     id: id ?? this.id,
      code: code ?? this.code,
      item: item ?? this.item,
      itemId: itemId ?? this.itemId,
      materialId: materialId ?? this.materialId,
      pcs: pcs ?? this.pcs,

      metal: metal ?? this.metal,
      grossWeight: grossWeight ?? this.grossWeight,
      netWeight: netWeight ?? this.netWeight,
      purity: purity ?? this.purity,
      jartiPercentage: jartiPercentage ?? this.jartiPercentage,
      jarti: jarti ?? this.jarti,
      jartiLal: jartiLal ?? this.jartiLal,
      
      jyala: jyala ?? this.jyala,
      jyalaPercentage: jyalaPercentage ?? this.jyalaPercentage,
      mrp: mrp ?? this.mrp,
      price: price ?? this.price,
      todayRate: todayRate ?? this.todayRate,
      rate: rate ?? this.rate,
      stone1Name: stone1Name ?? this.stone1Name,
      stone1Id: stone1Id ?? this.stone1Id,
      stone1Weight: stone1Weight ?? this.stone1Weight,
      stone1Price: stone1Price ?? this.stone1Price,
      stone2Name: stone2Name ?? this.stone2Name,
      stone2Id: stone2Id ?? this.stone2Id,
      stone2Weight: stone2Weight ?? this.stone2Weight,
      stone2Price: stone2Price ?? this.stone2Price,
      stone3Name: stone3Name ?? this.stone3Name,
      stone3Id: stone3Id ?? this.stone3Id,
      stone3Weight: stone3Weight ?? this.stone3Weight,
      stone3Price: stone3Price ?? this.stone3Price,
      baseAmount: baseAmount ?? this.baseAmount,
      nonTaxableAmount: nonTaxableAmount ?? this.nonTaxableAmount,
      taxableAmount: taxableAmount ?? this.taxableAmount,
      luxuryAmount: luxuryAmount ?? this.luxuryAmount,
      total: total ?? this.total,
      //discount: discount != null ? double.parse(discount) : this.discount,
      discount: discount ?? this.discount,//
      expectedAmount: expectedAmount ?? this.expectedAmount,
      
      expectedAmountDiscount: expectedAmountDiscount ?? this.expectedAmountDiscount,
      //expectedAmountDiscount: expectedAmountDiscount != null ? double.parse(expectedAmountDiscount) : this.expectedAmountDiscount,

       jartiAmount: jartiAmount ?? this.jartiAmount,
      // netWeightAmount: netWeightAmount ?? this.netWeightAmount,
      // stoneTotalPrice: stoneTotalPrice ?? this.stoneTotalPrice,

      newJyala: newJyala ?? this.newJyala,//
      newJyalaPercentage: newJyalaPercentage ?? this.newJyalaPercentage,//
      newJarti: newJarti ?? this.newJarti,//
      newJartiPercentage: newJartiPercentage ?? this.newJartiPercentage,//
      newJartiLal: newJartiLal ?? this.newJartiLal,//
      newJartiAmount: newJartiAmount ?? this.newJartiAmount,
      newStone1Price: newStone1Price ?? this.newStone1Price,
      newStone2Price: newStone2Price ?? this.newStone2Price,
      newStone3Price: newStone3Price ?? this.newStone3Price,
      newStoneTotalPrice: newStoneTotalPrice ?? this.newStoneTotalPrice,

      );
  }
 }
