import 'package:viovid_app/features/user_profile/dtos/user_profile.dart';

class UserProfileState {
  final bool isLoadingUserProfile;
  final bool isLoadingChangePassword;
  final UserProfile? userProfile;
  final String? errorMessage;

  UserProfileState({
    this.isLoadingUserProfile = false,
    this.isLoadingChangePassword = false,
    this.userProfile,
    this.errorMessage,
  });

  UserProfileState copyWith({
    bool? isLoadingUserProfile,
    bool? isLoadingChangePassword,
    UserProfile? userProfile,
    String? errorMessage,
  }) {
    return UserProfileState(
      isLoadingUserProfile: isLoadingUserProfile ?? this.isLoadingUserProfile,
      isLoadingChangePassword:
          isLoadingChangePassword ?? this.isLoadingChangePassword,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage,
    );
  }
}
