class ChangePasswordDto {
  String currentPassword;
  String newPassword;

  ChangePasswordDto({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currentPassword'] = currentPassword;
    data['newPassword'] = newPassword;
    return data;
  }
}
