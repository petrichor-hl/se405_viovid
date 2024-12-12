import 'dart:developer';

import 'package:viovid_app/features/films_by_genre/data/films_by_genre_api_service.dart';
import 'package:viovid_app/features/films_by_genre/dtos/genre_with_films.dart';
import 'package:viovid_app/features/result_type.dart';

class FilmsByGenreRepository {
  final FilmsByGenreApiService filmsByGenreApiService;

  FilmsByGenreRepository({
    required this.filmsByGenreApiService,
  });

  Future<Result<GenreWithFilms>> getFilmsByGenre(String genreId) async {
    try {
      return Success(await filmsByGenreApiService.getFilmsByGenre(genreId));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
