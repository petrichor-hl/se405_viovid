class RefreshTokenSuccessDto {
  final String accessToken;
  final String refreshToken;

  const RefreshTokenSuccessDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenSuccessDto.fromJson(Map<String, dynamic> json) {
    return RefreshTokenSuccessDto(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
