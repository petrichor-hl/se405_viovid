class UserProfile {
  String applicationUserId;
  String name;
  String email;
  String avatar;
  String? fcmToken;
  String planName;
  String? startDate;
  String? endDate;

  UserProfile({
    required this.applicationUserId,
    required this.name,
    required this.email,
    required this.avatar,
    this.fcmToken,
    required this.planName,
    this.startDate,
    this.endDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      applicationUserId: json['applicationUserId'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      fcmToken: json['fcmToken'],
      planName: json['planName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
