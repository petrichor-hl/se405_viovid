import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/films_by_genre/dtos/genre_with_films.dart';

class FilmsByGenreApiService {
  FilmsByGenreApiService(this.dio);

  final Dio dio;

  Future<GenreWithFilms> getFilmsByGenre(String genreId) async {
    try {
      return await ApiClient(dio).request<void, GenreWithFilms>(
        url: '/Genre/$genreId',
        method: ApiMethod.get,
        fromJson: (resultJson) => GenreWithFilms.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
