import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/person_detail/dtos/person.dart';

class PersonDetailApiService {
  PersonDetailApiService(this.dio);

  final Dio dio;

  Future<Person> getPersonDetail(String personId) async {
    try {
      return await ApiClient(dio).request<void, Person>(
        url: '/Person/$personId',
        method: ApiMethod.get,
        fromJson: (resultJson) => Person.fromJson(resultJson),
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
