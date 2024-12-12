part of 'films_by_genre_cubit.dart';

sealed class FilmsByGenreState {}

class FilmsByGenreInProgress extends FilmsByGenreState {}

class FilmsByGenreSuccess extends FilmsByGenreState {
  final GenreWithFilms genre;

  FilmsByGenreSuccess(this.genre);
}

class FilmsByGenreFailure extends FilmsByGenreState {
  final String message;

  FilmsByGenreFailure(this.message);
}
