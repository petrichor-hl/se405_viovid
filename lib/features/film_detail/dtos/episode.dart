class Episode {
  String id;
  int order;
  String title;
  String summary;
  String source;
  int duration;
  String stillPath;
  bool isFree;

  Episode({
    required this.id,
    required this.order,
    required this.title,
    required this.summary,
    required this.source,
    required this.duration,
    required this.stillPath,
    required this.isFree,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      order: json['order'],
      title: json['title'],
      summary: json['summary'],
      source: json['source'],
      duration: json['duration'],
      stillPath: json['stillPath'],
      isFree: json['isFree'],
    );
  }
}
