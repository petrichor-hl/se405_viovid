import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/topic/data/topic_list_repository.dart';
import 'package:viovid_app/features/topic/dtos/topic.dart';

part 'topic_list_state.dart';

// Cubit + Repository
class TopicListCubit extends Cubit<TopicListState> {
  final TopicListRepository _topicRepository;

  TopicListCubit(this._topicRepository) : super(TopicListInProgress());

  Future<void> getTopicList() async {
    final result = await _topicRepository.getTopicList();

    return (switch (result) {
      Success() => emit(TopicListSuccess(result.data)),
      Failure() => emit(TopicListFailure(result.message)),
    });
  }
}
