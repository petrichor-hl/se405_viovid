import 'dart:developer';

import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/search_film/data/search_film_api_service.dart';
import 'package:viovid_app/features/search_film/dtos/paging.dart';
import 'package:viovid_app/features/search_film/dtos/search_film_dto.dart';
import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class SearchFilmRepository {
  final SearchFilmApiService searchFilmApiService;

  SearchFilmRepository({
    required this.searchFilmApiService,
  });

  Future<Result<Paging<SimpleFilm>>> searchFilm(
    String searchText,
    // int pageIndex,
    // int pageSize,
  ) async {
    try {
      return Success(
        await searchFilmApiService.searchFilm(
          SearchFilmDto(
            searchText: searchText,
            pageIndex: 0,
            pageSize: 50,
          ),
        ),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
