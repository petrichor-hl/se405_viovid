class PayloadCreatePaymentUrlDto {
  String planId;

  PayloadCreatePaymentUrlDto({
    required this.planId,
  });

  Map<String, dynamic> toJson() => {
        "planId": planId,
      };
}
