import 'dart:developer';

import 'package:viovid_app/features/payment/dtos/payload_create_payment_url_dto.dart';
import 'package:viovid_app/features/payment/data/payment_api_service.dart';
import 'package:viovid_app/features/result_type.dart';

class PaymentRepository {
  final PaymentApiService paymentApiService;

  PaymentRepository({
    required this.paymentApiService,
  });

  Future<Result<String>> getPaymentUrl(String planId) async {
    try {
      return Success(
        await paymentApiService.getPaymentUrl(
          PayloadCreatePaymentUrlDto(planId: planId),
        ),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
