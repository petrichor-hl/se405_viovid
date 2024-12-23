class PostReviewDto {
  int start;
  String content;

  PostReviewDto({
    required this.start,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        "start": start,
        "content": content,
      };
}
