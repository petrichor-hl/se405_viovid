import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/film_detail/dtos/film.dart';

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
}
