class PaymentRecord {
  String paymentId;
  String planName;
  bool isDone;
  int? amount;
  DateTime? startDate;
  DateTime? endDate;

  PaymentRecord({
    required this.paymentId,
    required this.planName,
    required this.isDone,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) => PaymentRecord(
        paymentId: json["paymentId"],
        planName: json["planName"],
        isDone: json["isDone"],
        amount: json["amount"],
        startDate: DateTime.tryParse(json["startDate"] ?? ''),
        endDate: DateTime.tryParse(json["endDate"] ?? ''),
      );
}
