class Plan {
  final String id;
  final String name;
  final int price;
  final int duration;
  final int order;

  Plan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.order,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        duration: json["duration"],
        order: json["order"],
      );
}
