import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/user_profile/dtos/change_password_dto.dart';
import 'package:viovid_app/features/user_profile/dtos/tracking_progress.dart';
import 'package:viovid_app/features/user_profile/dtos/update_fcm_token_dto.dart';
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

  Future<List<TrackingProgress>> getTrackingProgress() async {
    try {
      return await ApiClient(dio).request<void, List<TrackingProgress>>(
        url: '/User/tracking-progress',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((trackingProgress) =>
                TrackingProgress.fromJson(trackingProgress))
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

  Future<bool> updateTrackingProgress(TrackingProgress trackingProgress) async {
    try {
      return await ApiClient(dio).request<TrackingProgress, bool>(
        url: '/User/tracking-progress',
        payload: trackingProgress,
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

  Future<bool> updateFcmToken(UpdateFcmTokenDto updateFcmTokenDto) async {
    try {
      return await ApiClient(dio).request<UpdateFcmTokenDto, bool>(
        url: '/Account/update-fcm-token',
        payload: updateFcmTokenDto,
        method: ApiMethod.put,
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
