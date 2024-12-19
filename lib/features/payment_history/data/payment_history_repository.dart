import 'dart:developer';

import 'package:viovid_app/features/payment_history/data/payment_history_api_service.dart';
import 'package:viovid_app/features/payment_history/dtos/payment_record.dart';
import 'package:viovid_app/features/result_type.dart';

class PaymentHistoryRepository {
  final PaymentHistoryApiService paymentHistoryApiService;

  PaymentHistoryRepository({
    required this.paymentHistoryApiService,
  });

  Future<Result<List<PaymentRecord>>> getPaymentHistory() async {
    try {
      return Success(await paymentHistoryApiService.getPaymentHistory());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
