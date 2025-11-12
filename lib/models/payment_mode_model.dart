class PaymentModeModel {
  final int id;
  final String name;
  int amount;
  PaymentModeModel(
      {required this.id, required this.name, required this.amount});

  factory PaymentModeModel.fromJson(Map<String, dynamic> json) {
    return PaymentModeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      amount: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
