import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/user-profile/data/user_profile_repository.dart';
import 'package:viovid_app/features/user-profile/dtos/user_profile.dart';

class UserProfileCubit extends Cubit<UserProfile?> {
  final UserProfileRepository userProfileRepository;

  UserProfileCubit(this.userProfileRepository) : super(null);

  Future<void> getUserProfile() async {
    final result = await userProfileRepository.getUserProfile();
    return (switch (result) {
      Success() => emit(result.data),
      Failure() => emit(null),
    });
  }
}
