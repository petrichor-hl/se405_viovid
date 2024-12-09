import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/film_detail/dtos/film.dart';
import 'package:viovid_app/features/film_detail/dtos/season.dart';

class FilmDetailApiService {
  FilmDetailApiService(this.dio);

  final Dio dio;

  Future<Film> getFilmDetail(String filmId) async {
    try {
      return await ApiClient(dio).request<void, Film>(
        url: '/Film/$filmId',
        method: ApiMethod.get,
        fromJson: (resultJson) => Film.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<Season> getSeasonById(String filmId, String seasonId) async {
    try {
      return await ApiClient(dio).request<void, Season>(
        url: '/Film/$filmId/seasons/$seasonId',
        method: ApiMethod.get,
        fromJson: (resultJson) => Season.fromJson(resultJson),
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
