import 'dart:developer';

import 'package:viovid_app/features/my_list/data/my_list_api_service.dart';
import 'package:viovid_app/features/my_list/dtos/payload_add_film.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class MyListRepository {
  final MyListApiService myListApiService;

  MyListRepository({
    required this.myListApiService,
  });

  Future<Result<List<SimpleFilm>>> getMyList() async {
    try {
      return Success(await myListApiService.getMyList());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<SimpleFilm>> addFilmToMyList(String filmId) async {
    try {
      return Success(
        await myListApiService.addFilmToMyList(
          PayloadAddFilm(filmId: filmId),
        ),
      );
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> removeFilmFromMyList(String filmId) async {
    try {
      return Success(await myListApiService.removeFilmFromMyList(filmId));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
