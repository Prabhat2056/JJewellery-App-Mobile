class CashierModel {
  final int id;
  final String name;

  CashierModel({required this.id, required this.name});

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    return CashierModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
