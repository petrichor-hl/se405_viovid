import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class GenreWithFilms {
  String id;
  String name;
  List<SimpleFilm> films;

  GenreWithFilms({
    required this.id,
    required this.name,
    required this.films,
  });

  factory GenreWithFilms.fromJson(Map<String, dynamic> json) {
    return GenreWithFilms(
      id: json['id'],
      name: json['name'],
      films: (json['films'] as List)
          .map((film) => SimpleFilm.fromJson(film))
          .toList(),
    );
  }
}
