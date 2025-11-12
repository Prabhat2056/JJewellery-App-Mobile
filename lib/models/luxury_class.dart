class Luxury {
  final String id;
  final String title;
  final double amount;
  final String? description;
  final DateTime date;

  Luxury({
    required this.id,
    required this.title,
    required this.amount,
    this.description,
    required this.date,
  });
}