import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/user-profile/dtos/user_profile.dart';

class UserProfileApiService {
  UserProfileApiService(this.dio);

  final Dio dio;

  Future<UserProfile> getUserProfile() async {
    try {
      return await ApiClient(dio).request<void, UserProfile>(
        url: '/User/profile',
        method: ApiMethod.get,
        fromJson: (resultJson) => UserProfile.fromJson(resultJson),
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
