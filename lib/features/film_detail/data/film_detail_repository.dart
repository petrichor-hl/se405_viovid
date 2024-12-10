import 'package:viovid_app/features/film_detail/data/film_detail_api_service.dart';
import 'package:viovid_app/features/film_detail/dtos/cast.dart';
import 'package:viovid_app/features/film_detail/dtos/film.dart';
import 'package:viovid_app/features/film_detail/dtos/season.dart';
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

  Future<Result<Season>> getSeasonById(String filmId, String seasonId) async {
    try {
      return Success(
          await filmDetailApiService.getSeasonById(filmId, seasonId));
    } catch (error) {
      return Failure('$error');
    }
  }

  Future<Result<List<Cast>>> getCasts(String filmId) async {
    try {
      return Success(await filmDetailApiService.getCasts(filmId));
    } catch (error) {
      return Failure('$error');
    }
  }
}
