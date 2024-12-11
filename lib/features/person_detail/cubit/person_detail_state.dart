part of 'person_detail_cubit.dart';

sealed class PersonDetailState {}

class PersonDetailInProgress extends PersonDetailState {}

class PersonDetailSuccess extends PersonDetailState {
  final Person person;

  PersonDetailSuccess(this.person);
}

class PersonDetailFailure extends PersonDetailState {
  final String message;

  PersonDetailFailure(this.message);
}
