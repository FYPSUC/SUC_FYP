class PredictionData {
  final int hour; // 例如 "10:00", "14:00" 等
  final double amount;

  PredictionData({
    required this.hour,
    required this.amount,
  });

  factory PredictionData.fromJson(Map<String, dynamic> json) {
    return PredictionData(
      hour: json['hour'] is String ? int.parse(json['hour']) : json['hour'],
      amount: (json['predicted'] as num).toDouble(),
    );
  }
}
