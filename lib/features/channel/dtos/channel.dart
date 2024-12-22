import 'package:viovid_app/features/channel/dtos/user_channel.dart';

class Channel {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  List<UserChannel> userChannels = [];

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.userChannels,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    var userChannels = (json['userChannels'] as List)
        .map((item) => UserChannel(
              applicationUserId: item['applicationUserId'],
              channelId: item['channelId'],
            ))
        .toList();
    return Channel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      userChannels: userChannels,
    );
  }
}
