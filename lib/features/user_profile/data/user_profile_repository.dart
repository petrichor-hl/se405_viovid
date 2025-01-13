import 'dart:developer';

import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_api_service.dart';
import 'package:viovid_app/features/user_profile/dtos/change_password_dto.dart';
import 'package:viovid_app/features/user_profile/dtos/tracking_progress.dart';
import 'package:viovid_app/features/user_profile/dtos/update_fcm_token_dto.dart';
import 'package:viovid_app/features/user_profile/dtos/update_thread_id.dart';
import 'package:viovid_app/features/user_profile/dtos/user_profile.dart';

class UserProfileRepository {
  final UserProfileApiService userProfileApiService;

  UserProfileRepository({
    required this.userProfileApiService,
  });

  Future<Result<UserProfile>> getUserProfile() async {
    try {
      return Success(await userProfileApiService.getUserProfile());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<Map<String, int>>> getTrackingProgress() async {
    try {
      final result = await userProfileApiService.getTrackingProgress();
      Map<String, int> trackingMap = {};
      for (var item in result) {
        trackingMap[item.episodeId] = item.progress;
      }
      return Success(trackingMap);
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> updateTrackingProgress(
    TrackingProgress trackingProgress,
  ) async {
    try {
      return Success(
          await userProfileApiService.updateTrackingProgress(trackingProgress));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> changePassword(
      String currentPassword, String newPassword) async {
    try {
      return Success(
        await userProfileApiService.changePassword(
          ChangePasswordDto(
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
        ),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> updateFcmToken(
    String fcmToken,
  ) async {
    try {
      return Success(
        await userProfileApiService.updateFcmToken(
          UpdateFcmTokenDto(fcmToken: fcmToken),
        ),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> updateThreadId(String? threadId) async {
    try {
      return Success(
        await userProfileApiService.updateThreadId(
          UpdateThreadIdDto(threadId: threadId),
        ),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
