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
        'jartiPercent': jartiPercentage,
        'jyalaAmount': jyala.replaceAll(',', '').trim(),
        //'luxuryPercent': luxuryPercentage,//
        'luxuryAmount': luxuryAmount.toStringAsFixed(2),
        'baseAmount': baseAmount.toStringAsFixed(2),
        'nonTaxableAmount': nonTaxableAmount.toStringAsFixed(2),
        'taxableAmount': taxableAmount.toStringAsFixed(2),
        'totalAmount': total.toStringAsFixed(2),
        'expectedAmount': expectedAmount.replaceAll(',', '').trim(),
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
        'purity': purity.replaceAll(RegExp(r'[Kk]'), '')
      };
}
