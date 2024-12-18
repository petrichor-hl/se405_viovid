import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/register_plan/dtos/plan.dart';

class RegisterPlanApiService {
  RegisterPlanApiService(this.dio);

  final Dio dio;

  Future<List<Plan>> getListPlan() async {
    try {
      return await ApiClient(dio).request<void, List<Plan>>(
        url: '/Plan',
        method: ApiMethod.get,
        fromJson: (resultJson) =>
            (resultJson as List).map((plan) => Plan.fromJson(plan)).toList(),
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
