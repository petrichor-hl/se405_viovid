import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/payment/dtos/payload_create_payment_url_dto.dart';

class PaymentApiService {
  PaymentApiService(this.dio);

  final Dio dio;

  Future<String> getPaymentUrl(PayloadCreatePaymentUrlDto payload) async {
    try {
      return await ApiClient(dio).request<PayloadCreatePaymentUrlDto, String>(
        url: '/Payment/vn-pay',
        payload: payload,
        method: ApiMethod.post,
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
