import 'dart:developer';

import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_api_service.dart';
import 'package:viovid_app/features/user_profile/dtos/change_password_dto.dart';
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
}
