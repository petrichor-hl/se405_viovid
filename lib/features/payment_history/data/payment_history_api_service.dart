import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/payment_history/dtos/payment_record.dart';

class PaymentHistoryApiService {
  PaymentHistoryApiService(this.dio);

  final Dio dio;

  Future<List<PaymentRecord>> getPaymentHistory() async {
    try {
      return await ApiClient(dio).request<void, List<PaymentRecord>>(
        url: '/User/user-payments',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((record) => PaymentRecord.fromJson(record))
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
