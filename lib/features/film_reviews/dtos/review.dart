class Review {
  String id;
  String userName;
  String userAvatar;
  int start;
  String content;
  DateTime createAt;

  Review({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.start,
    required this.content,
    required this.createAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        userName: json["userName"],
        userAvatar: json["userAvatar"],
        start: json["start"],
        content: json["content"],
        createAt: DateTime.parse(json["createAt"]),
      );
}
