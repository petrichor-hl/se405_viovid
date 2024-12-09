class SimpleSeason {
  String id;
  int order;
  String name;

  SimpleSeason({
    required this.id,
    required this.order,
    required this.name,
  });

  factory SimpleSeason.fromJson(Map<String, dynamic> json) {
    return SimpleSeason(
      id: json['id'],
      order: json['order'],
      name: json['name'],
    );
  }
}
