import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/film_detail/dtos/cast.dart';
import 'package:viovid_app/features/film_detail/dtos/crew.dart';
import 'package:viovid_app/features/film_detail/dtos/film.dart';
import 'package:viovid_app/features/film_detail/dtos/season.dart';
import 'package:viovid_app/features/topic/dtos/simple_film.dart';

import 'package:http/http.dart' as http;

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

  Future<List<Cast>> getCasts(String filmId) async {
    try {
      return await ApiClient(dio).request<void, List<Cast>>(
        url: '/Film/$filmId/casts',
        method: ApiMethod.get,
        fromJson: (resultJson) =>
            (resultJson as List).map((cast) => Cast.fromJson(cast)).toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<List<Crew>> getCrews(String filmId) async {
    try {
      return await ApiClient(dio).request<void, List<Crew>>(
        url: '/Film/$filmId/crews',
        method: ApiMethod.get,
        fromJson: (resultJson) =>
            (resultJson as List).map((crew) => Crew.fromJson(crew)).toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  final tmdbApiKey = "a29284b32c092cc59805c9f5513d3811";

  Future<List<SimpleFilm>> getRecommendations(
    String type,
    String filmId,
  ) async {
    try {
      log('$ApiMethod.get - $type/$filmId/recommendations - ⏰');

      final response = await Dio().get(
        'https://api.themoviedb.org/3/$type/$filmId/recommendations',
        queryParameters: {
          "api_key": tmdbApiKey,
        },
      );

      List<SimpleFilm> films = [];
      for (var film in (response.data['results'] as List)) {
        if (film['adult'] == false && film['poster_path'] != null) {
          films.add(
            SimpleFilm(
              filmId: film['id'].toString(),
              name: film[type == 'movie' ? 'title' : 'name'],
              posterPath:
                  'https://image.tmdb.org/t/p/w440_and_h660_face${film['poster_path']}',
            ),
          );
        }
      }

      log('$ApiMethod.get - $type/$filmId/recommendations - ✅');

      return films;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<bool> countView(String filmId) async {
    try {
      return await ApiClient(dio).request<void, bool>(
        url: '/Film/$filmId/count-view',
        method: ApiMethod.post,
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
