class RefreshTokenDto {
  final String accessToken;
  final String refreshToken;

  const RefreshTokenDto({
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}
