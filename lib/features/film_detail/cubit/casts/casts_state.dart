import 'package:viovid_app/features/film_detail/dtos/cast.dart';

sealed class CastsState {}

class CastsInitial extends CastsState {}

class CastsInProgress extends CastsState {}

class CastsSuccess extends CastsState {
  final List<Cast> casts;

  CastsSuccess(this.casts);
}

class CastsFailure extends CastsState {
  final String message;

  CastsFailure(this.message);
}
