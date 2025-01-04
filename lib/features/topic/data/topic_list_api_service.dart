import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/topic/dtos/topic.dart';

class TopicListApiService {
  TopicListApiService(this.dio);

  final Dio dio;

  Future<List<Topic>> getTopicList() async {
    try {
      return await ApiClient(dio).request<void, List<Topic>>(
        url: '/Topic/browse',
        method: ApiMethod.get,
        fromJson: (resultJson) {
          return (resultJson as List)
              .map((topic) => Topic.fromJson(topic))
              .toList();
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
