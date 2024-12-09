import 'package:viovid_app/features/film_detail/dtos/episode.dart';
import 'package:viovid_app/features/film_detail/dtos/simple_season.dart';

class Season extends SimpleSeason {
  List<Episode> episodes;

  Season({
    required super.id,
    required super.order,
    required super.name,
    required this.episodes,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      order: json['order'],
      name: json['name'],
      episodes: (json['episodes'] as List)
          .map((episode) => Episode.fromJson(episode))
          .toList(),
    );
  }
}
