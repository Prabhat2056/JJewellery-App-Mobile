class OldJewelleryModel {
  final String id;
  final int itemId;
  final String item;
  final int materialId;
  final String material;
  final double rate;
  final double qtyGram;
  final double wasteGram;
  final double finalQty;

  OldJewelleryModel({
    required this.id,
    required this.itemId,
    required this.item,
    required this.materialId,
    required this.material,
    required this.rate,
    required this.qtyGram,
    required this.wasteGram,
    required this.finalQty,
  });

  Map<String, dynamic> toJson() => {
        'id': '0',
        'itemId': itemId,
        'item': item,
        'materialId': materialId,
        'material': material,
        'rate': rate,
        'qtyGram': qtyGram,
        'wasteGram': wasteGram,
        'finalQty': finalQty,
      };
}
