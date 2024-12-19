class PaymentRecord {
  String userPlanId;
  String planName;
  int amount;
  DateTime startDate;
  DateTime endDate;

  PaymentRecord({
    required this.userPlanId,
    required this.planName,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) => PaymentRecord(
        userPlanId: json["userPlanId"],
        planName: json["planName"],
        amount: json["amount"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );
}
