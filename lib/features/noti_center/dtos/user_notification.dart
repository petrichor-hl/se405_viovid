// enum NotificationCategory {
//   film = 0
//   post = 1
// }

// enum NotificationReadStatus {
//   unread = 0
//   read = 1
// }

class UserNotification {
  String id;
  // String? applicationUserId;
  int category; // NotificationCategory
  DateTime createdDateTime;
  // int readStatus; // NotificationReadStatus
  // String title;
  // String body;
  Map<String, dynamic> params;

  UserNotification({
    required this.id,
    // required this.applicationUserId,
    required this.category,
    required this.createdDateTime,
    // required this.readStatus,
    // required this.title,
    // required this.body,
    required this.params,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) =>
      UserNotification(
        id: json["id"],
        // applicationUserId: json["applicationUserId"],
        category: json["category"],
        createdDateTime: DateTime.parse(json["createdDateTime"]),
        // readStatus: json["readStatus"],
        // title: json["title"],
        // body: json["body"],
        params: json["params"],
      );
}
