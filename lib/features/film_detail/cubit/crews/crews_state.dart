import 'package:viovid_app/features/film_detail/dtos/crew.dart';

sealed class CrewsState {}

class CrewsInitial extends CrewsState {}

class CrewsInProgress extends CrewsState {}

class CrewsSuccess extends CrewsState {
  final List<Crew> crews;

  CrewsSuccess(this.crews);
}

class CrewsFailure extends CrewsState {
  final String message;

  CrewsFailure(this.message);
}
