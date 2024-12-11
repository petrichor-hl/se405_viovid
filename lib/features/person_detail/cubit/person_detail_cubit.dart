import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/person_detail/data/person_detail_repository.dart';
import 'package:viovid_app/features/person_detail/dtos/person.dart';
import 'package:viovid_app/features/result_type.dart';

part 'person_detail_state.dart';

// Cubit + Repository
class PersonDetailCubit extends Cubit<PersonDetailState> {
  final PersonDetailRepository _personDetailRepository;

  PersonDetailCubit(this._personDetailRepository)
      : super(PersonDetailInProgress());

  Future<void> getPersonDetail(String personId) async {
    final result = await _personDetailRepository.getPersonDetail(personId);
    return (switch (result) {
      Success() => emit(PersonDetailSuccess(result.data)),
      Failure() => emit(PersonDetailFailure(result.message)),
    });
  }
}
