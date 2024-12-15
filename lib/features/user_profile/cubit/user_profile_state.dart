import 'package:viovid_app/features/user_profile/dtos/user_profile.dart';

class UserProfileState {
  final bool isLoadingUserProfile;
  final bool isLoadingChangePassword;
  final UserProfile? userProfile;
  final Map<String, int>? userTrackingProgress;
  final String? errorMessage;

  UserProfileState({
    this.isLoadingUserProfile = false,
    this.isLoadingChangePassword = false,
    this.userProfile,
    this.userTrackingProgress,
    this.errorMessage,
  });

  UserProfileState copyWith({
    bool? isLoadingUserProfile,
    bool? isLoadingChangePassword,
    UserProfile? userProfile,
    Map<String, int>? userTrackingProgress,
    String? errorMessage,
  }) {
    return UserProfileState(
      isLoadingUserProfile: isLoadingUserProfile ?? this.isLoadingUserProfile,
      isLoadingChangePassword:
          isLoadingChangePassword ?? this.isLoadingChangePassword,
      userProfile: userProfile ?? this.userProfile,
      userTrackingProgress: userTrackingProgress ?? this.userTrackingProgress,
      errorMessage: errorMessage,
    );
  }
}
