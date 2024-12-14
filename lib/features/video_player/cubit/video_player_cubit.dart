import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/video_player/cubit/video_player_state.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit() : super(VideoPlayerState());

  void setState({bool? isPlaying, double? newProgress}) {
    emit(
      VideoPlayerState(
        isPlaying: isPlaying ?? state.isPlaying,
        progress: newProgress ?? state.progress,
      ),
    );
  }
}
