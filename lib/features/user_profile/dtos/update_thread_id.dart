class UpdateThreadIdDto {
  String? threadId;

  UpdateThreadIdDto({
    required this.threadId,
  });

  Map<String, dynamic> toJson() => {
        "threadId": threadId,
      };
}
