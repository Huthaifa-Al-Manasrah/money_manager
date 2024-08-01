class TransactionEntity {
  final String id;
  final String title;
  final String description;
  final String? imagePath;
  final DateTime date;
  final double amount;
  final bool isInput;

  TransactionEntity({required this.id, required this.title, required this.description, this.imagePath, required this.date, required this.amount, required this.isInput});
}