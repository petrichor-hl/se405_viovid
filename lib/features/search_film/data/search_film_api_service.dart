import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/search_film/dtos/paging.dart';
import 'package:viovid_app/features/search_film/dtos/search_film_dto.dart';
import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class SearchFilmApiService {
  SearchFilmApiService(this.dio);

  final Dio dio;

  Future<Paging<SimpleFilm>> searchFilm(SearchFilmDto searchFilmDto) async {
    try {
      return await ApiClient(dio).request<SearchFilmDto, Paging<SimpleFilm>>(
        url: '/Film',
        queryParameters: searchFilmDto.toJson(),
        method: ApiMethod.get,
        fromJson: (resultJson) => Paging.fromJson(
          resultJson,
          (item) => SimpleFilm.fromJson(item),
        ),
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
