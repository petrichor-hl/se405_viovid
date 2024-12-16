import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class Person {
  String id;
  String name;
  int gender;
  double popularity;
  String? profilePath;
  String? biography;
  String knownForDepartment;
  DateTime? dob;
  List<SimpleFilm> films;

  Person({
    required this.id,
    required this.name,
    required this.gender,
    required this.popularity,
    required this.profilePath,
    required this.biography,
    required this.knownForDepartment,
    required this.dob,
    required this.films,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      // popularity: (json['popularity'] as int).toDouble(),
      popularity: json['popularity'],
      profilePath: json['profilePath'],
      biography: json['biography'],
      knownForDepartment: json['knownForDepartment'],
      dob: DateTime.tryParse(json['dob'] ?? ''),
      films: (json['films'] as List)
          .map((film) => SimpleFilm.fromJson(film))
          .toList(),
    );
  }
}
