class UserTransaction {
  final String type; // 'topup', 'order', 'clinic'
  final String title;
  final double amount;
  final DateTime date;
  final int? orderId;

  UserTransaction({
    required this.type,
    required this.title,
    required this.amount,
    required this.date,
    this.orderId,
  });

  factory UserTransaction.fromJson(Map<String, dynamic> json) {
    return UserTransaction(
      type: json['type'],
      title: json['title'],
      amount: double.parse(json['amount'].toString()), // 💡强制转成 double
      date: DateTime.parse(json['date']),
      orderId: json['order_id'] != null ? int.tryParse(json['order_id'].toString()) : null,
    );
  }

}
