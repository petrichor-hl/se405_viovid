class UpdateReadStatusDto {
  String notificationId;

  UpdateReadStatusDto({
    required this.notificationId,
  });

  Map<String, dynamic> toJson() => {
        'notificationId': notificationId,
      };
}
