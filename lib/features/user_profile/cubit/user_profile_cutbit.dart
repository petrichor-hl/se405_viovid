import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_state.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_repository.dart';
import 'package:viovid_app/features/user_profile/dtos/tracking_progress.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileRepository userProfileRepository;

  UserProfileCubit(this.userProfileRepository) : super(UserProfileState());

  Future<void> getUserProfile() async {
    emit(
      state.copyWith(
        isLoadingUserProfile: true,
        errorMessage: null,
      ),
    );
    final result = await userProfileRepository.getUserProfile();
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoadingUserProfile: false,
            userProfile: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoadingUserProfile: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> getTrackingProgress() async {
    emit(
      state.copyWith(
        isLoadingUserProfile: true,
        errorMessage: null,
      ),
    );
    final result = await userProfileRepository.getTrackingProgress();
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoadingUserProfile: false,
            userTrackingProgress: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoadingUserProfile: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> updateTrackingProgress(TrackingProgress trackingProgress) async {
    final newUserTrackingProgress = {
      ...?state.userTrackingProgress,
      trackingProgress.episodeId: trackingProgress.progress
    };

    emit(
      state.copyWith(
        userTrackingProgress: newUserTrackingProgress,
      ),
    );
    final result =
        await userProfileRepository.updateTrackingProgress(trackingProgress);
    switch (result) {
      case Success():
        break;
      case Failure():
        emit(
          state.copyWith(
            isLoadingUserProfile: false,
            errorMessage: result.message,
          ),
        );
        break;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    emit(
      state.copyWith(
        isLoadingChangePassword: true,
        errorMessage: null,
      ),
    );
    final result = await userProfileRepository.changePassword(
        currentPassword, newPassword);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoadingChangePassword: false,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoadingChangePassword: false,
            errorMessage: result.message,
          ),
        ),
    });
  }
}
