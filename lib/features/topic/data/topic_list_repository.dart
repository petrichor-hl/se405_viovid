import 'dart:developer';

import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/topic/data/topic_list_api_service.dart';
import 'package:viovid_app/features/topic/dtos/topic.dart';

class TopicListRepository {
  final TopicListApiService topicApiService;

  TopicListRepository({
    required this.topicApiService,
  });

  Future<Result<List<Topic>>> getTopicList() async {
    try {
      return Success(await topicApiService.getTopicList());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
