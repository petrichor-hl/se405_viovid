import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class Topic {
  String topicId;
  int order;
  String name;
  List<SimpleFilm> films;

  Topic({
    required this.topicId,
    required this.order,
    required this.name,
    required this.films,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['topicId'],
      order: json['order'],
      name: json['name'],
      films: (json['films'] as List)
          .map((film) => SimpleFilm.fromJson(film))
          .toList(),
    );
  }
}
