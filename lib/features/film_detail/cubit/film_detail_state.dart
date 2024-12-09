part of 'film_detail_cubit.dart';

sealed class FilmDetailState {}

class FilmDetailInProgress extends FilmDetailState {}

class FilmDetailSuccess extends FilmDetailState {
  final Film film;

  FilmDetailSuccess(this.film);
}

class FilmDetailFailure extends FilmDetailState {
  final String message;

  FilmDetailFailure(this.message);
}
