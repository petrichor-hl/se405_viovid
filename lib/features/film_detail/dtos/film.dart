import 'package:viovid_app/features/film_detail/dtos/genre.dart';
import 'package:viovid_app/features/film_detail/dtos/season.dart';
import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class Film extends SimpleFilm {
  String overview;
  String backdropPath;
  String contentRating;
  String releaseDate;
  List<Season> seasons;
  List<Genre> genres;

  Film({
    required super.filmId,
    required super.name,
    required super.posterPath,
    required this.overview,
    required this.backdropPath,
    required this.contentRating,
    required this.releaseDate,
    required this.seasons,
    required this.genres,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      filmId: json['filmId'],
      name: json['name'],
      posterPath: json['posterPath'],
      overview: json['overview'],
      backdropPath: json['backdropPath'],
      contentRating: json['contentRating'],
      releaseDate: json['releaseDate'],
      seasons: (json['seasons'] as List)
          .map((season) => Season.fromJson(season))
          .toList(),
      genres: (json['genres'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList(),
    );
  }
}