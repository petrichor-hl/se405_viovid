class UserProfile {
  String applicationUserId;
  String name;
  String email;
  String avatar;
  String planName;
  String? startDate;
  String? endDate;
  String? fcmToken;
  String? threadId;

  UserProfile({
    required this.applicationUserId,
    required this.name,
    required this.email,
    required this.avatar,
    required this.planName,
    this.startDate,
    this.endDate,
    this.fcmToken,
    this.threadId,
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
      threadId: json['threadId'],
    );
  }
}
