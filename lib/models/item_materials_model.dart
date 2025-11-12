class ItemMaterialsModel {
  String name;
  int id;
  ItemMaterialsModel({required this.name, required this.id});

  factory ItemMaterialsModel.fromJson(Map<String, dynamic> json) {
    return ItemMaterialsModel(
      name: json['name'],
      id: json['id'],
    );
  }
}
