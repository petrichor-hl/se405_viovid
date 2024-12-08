part of 'topic_list_cubit.dart';

sealed class TopicListState {}

class TopicListInProgress extends TopicListState {}

class TopicListSuccess extends TopicListState {
  final List<Topic> topicList;

  TopicListSuccess(this.topicList);
}

class TopicListFailure extends TopicListState {
  final String message;

  TopicListFailure(this.message);
}
