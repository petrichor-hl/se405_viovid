class Season {
  String id;
  int order;
  String name;

  Season({
    required this.id,
    required this.order,
    required this.name,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      order: json['order'],
      name: json['name'],
    );
  }
}
