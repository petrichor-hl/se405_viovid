class UpdateFcmTokenDto {
  String fcmToken;

  UpdateFcmTokenDto({
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
        "fcmToken": fcmToken,
      };
}
