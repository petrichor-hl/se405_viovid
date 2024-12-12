import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/films_by_genre/data/films_by_genre_repository.dart';
import 'package:viovid_app/features/films_by_genre/dtos/genre_with_films.dart';
import 'package:viovid_app/features/result_type.dart';

part 'films_by_genre_state.dart';

// Cubit + Repository
class FilmsByGenreCubit extends Cubit<FilmsByGenreState> {
  final FilmsByGenreRepository _filmsByGenreRepository;

  FilmsByGenreCubit(this._filmsByGenreRepository)
      : super(FilmsByGenreInProgress());

  Future<void> getGenreWithFilms(String genreId) async {
    final result = await _filmsByGenreRepository.getFilmsByGenre(genreId);

    return (switch (result) {
      Success() => emit(FilmsByGenreSuccess(result.data)),
      Failure() => emit(FilmsByGenreFailure(result.message)),
    });
  }
}
