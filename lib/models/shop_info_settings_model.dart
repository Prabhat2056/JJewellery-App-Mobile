class ShopInfoSettingsModel {
  final String name;
  final String shortName;
  final String contact;
  final String address;
  final String pan;
  String? logo;

  ShopInfoSettingsModel({
    required this.name,
    required this.shortName,
    required this.contact,
    required this.address,
    required this.pan,
    this.logo,
  });
}
