class LoginSuccessDto {
  final String accessToken;
  final String refreshToken;

  const LoginSuccessDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginSuccessDto.fromJson(Map<String, dynamic> json) {
    return LoginSuccessDto(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
