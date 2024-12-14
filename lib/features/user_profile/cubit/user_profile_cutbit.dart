import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_state.dart';
import 'package:viovid_app/features/user_profile/data/user_profile_repository.dart';

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
