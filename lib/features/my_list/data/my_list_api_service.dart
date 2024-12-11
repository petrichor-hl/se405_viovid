import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/my_list/dtos/payload_add_film.dart';
import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class MyListApiService {
  MyListApiService(this.dio);

  final Dio dio;

  Future<List<SimpleFilm>> getMyList() async {
    try {
      return await ApiClient(dio).request<void, List<SimpleFilm>>(
        url: '/User/my-list',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((film) => SimpleFilm.fromJson(film))
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<SimpleFilm> addFilmToMyList(PayloadAddFilm payload) async {
    try {
      return await ApiClient(dio).request<PayloadAddFilm, SimpleFilm>(
        url: '/User/my-list',
        method: ApiMethod.post,
        payload: payload,
        fromJson: (resultJson) => SimpleFilm.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> removeFilmFromMyList(String filmId) async {
    try {
      return await ApiClient(dio).request<PayloadAddFilm, String>(
        url: '/User/my-list/$filmId',
        method: ApiMethod.delete,
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
