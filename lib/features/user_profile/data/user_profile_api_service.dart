import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/user_profile/dtos/change_password_dto.dart';
import 'package:viovid_app/features/user_profile/dtos/user_profile.dart';

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

  Future<bool> changePassword(ChangePasswordDto changePasswordDto) async {
    try {
      return await ApiClient(dio).request<ChangePasswordDto, bool>(
        method: ApiMethod.post,
        url: '/Account/change-password',
        payload: changePasswordDto,
      );
    } on DioException catch (e) {
      print(e);
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
