import 'package:viovid_app/features/film_detail/data/film_detail_api_service.dart';
import 'package:viovid_app/features/film_detail/dtos/film.dart';
import 'package:viovid_app/features/result_type.dart';

class FilmDetailRepository {
  final FilmDetailApiService filmDetailApiService;

  FilmDetailRepository({
    required this.filmDetailApiService,
  });

  Future<Result<Film>> getFilmDetail(String filmId) async {
    try {
      return Success(await filmDetailApiService.getFilmDetail(filmId));
    } catch (error) {
      return Failure('$error');
    }
  }
}
