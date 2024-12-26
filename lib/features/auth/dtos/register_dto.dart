class RegisterDto {
  String email;
  String password;
  String name;

  RegisterDto({
    required this.email,
    required this.password,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "name": name,
      };
}
