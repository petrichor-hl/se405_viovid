import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:viovid_app/features/film_detail/dtos/episode.dart';
import 'package:viovid_app/features/film_detail/dtos/season.dart';
import 'package:viovid_app/features/video_player/cubit/video_player_cubit.dart';
import 'package:viovid_app/features/video_player/cubit/video_player_state.dart';
import 'package:viovid_app/screens/video_player/components/brightness_bar.dart';
import 'package:viovid_app/screens/video_player/components/season_modal_bottom_sheet.dart';
import 'package:viovid_app/screens/video_player/components/video_progress_bar.dart';
import 'package:viovid_app/screens/video_player/components/video_speed_dialog.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.filmName,
    required this.seasons,
    required this.firstEpisodeIdToPlay,
  });

  final String filmName;
  final List<Season> seasons;
  final String firstEpisodeIdToPlay;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;

  bool _controlsOverlayVisible = false;

  late int _currentEpisodeIndex;
  late int _currentSeasonIndex;

  late Timer _controlsTimer = Timer(Duration.zero, () {});

  void _startCountdownToDismissControls() {
    _controlsTimer = Timer(const Duration(seconds: 100), () {
      setState(() {
        _controlsOverlayVisible = false;
      });
    });
  }

  void _onVideoPlayerPositionChanged() {
    context.read<VideoPlayerCubit>().setState(
          isPlaying: _videoPlayerController.value.isPlaying,
          newProgress: _videoPlayerController.value.position.inMilliseconds /
              _videoPlayerController.value.duration.inMilliseconds,
        );
  }

  void _toggleControlsOverlay() {
    _controlsTimer.cancel();

    setState(() {
      _controlsOverlayVisible = !_controlsOverlayVisible;
    });

    if (_controlsOverlayVisible) {
      // Hide the overlay after a delay
      _startCountdownToDismissControls();
    }
  }

  void setVideoController(Episode episode) {
    _controlsTimer.cancel();

    setState(() {
      _controlsOverlayVisible = false;
    });

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(episode.source),
    );

    _videoPlayerController.initialize().then((value) {
      _videoPlayerController.addListener(_onVideoPlayerPositionChanged);
      setState(() {
        _controlsOverlayVisible = true;
      });
      _videoPlayerController
          .play()
          .then((_) => _startCountdownToDismissControls());
    });
  }

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    try {
      ScreenBrightness().setApplicationScreenBrightness(1);
    } catch (e) {
      //
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    for (int i = 0; i < widget.seasons.length; ++i) {
      for (int j = 0; j < widget.seasons[i].episodes.length; ++j) {
        if (widget.seasons[i].episodes[j].id == widget.firstEpisodeIdToPlay) {
          setVideoController(widget.seasons[i].episodes[j]);
          _currentSeasonIndex = i;
          _currentEpisodeIndex = j;
        }
      }
    }
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    try {
      ScreenBrightness().resetApplicationScreenBrightness();
    } catch (e) {
      //
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _videoPlayerController.dispose();
    _controlsTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingSide = max(
      max(
        MediaQuery.of(context).padding.left,
        MediaQuery.of(context).padding.right,
      ),
      20,
    ).toDouble();

    final isLastEpisode = _currentSeasonIndex == widget.seasons.length - 1 &&
        _currentEpisodeIndex ==
            widget.seasons[_currentSeasonIndex].episodes.length - 1;

    final isMovie = widget.seasons.length == 1 &&
        widget.seasons[_currentSeasonIndex].episodes.length == 1;

    return Scaffold(
      body: GestureDetector(
        onTap: _videoPlayerController.value.isInitialized
            ? _toggleControlsOverlay
            : null,
        child: Stack(
          children: [
            /* Video */
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.isInitialized
                    ? _videoPlayerController.value.aspectRatio
                    : 16 / 9,
                child: _videoPlayerController.value.isInitialized
                    ? VideoPlayer(_videoPlayerController)
                    : const Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                        ),
                      ),
              ),
            ),
            /* Controls Button */
            AnimatedOpacity(
              opacity: _controlsOverlayVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.black54,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: IgnorePointer(
                    ignoring: !_controlsOverlayVisible,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _videoPlayerController.seekTo(
                              _videoPlayerController.value.position -
                                  const Duration(seconds: 10),
                            );
                            _controlsTimer.cancel();
                            _startCountdownToDismissControls();
                          },
                          icon: const Icon(
                            Icons.replay_10_rounded,
                            size: 60,
                          ),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const Gap(50),
                        BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
                          builder: (ctx, state) {
                            return IconButton(
                              onPressed: () {
                                state.isPlaying == true
                                    ? _videoPlayerController.pause()
                                    : _videoPlayerController.play();
                                _controlsTimer.cancel();
                                _startCountdownToDismissControls();
                              },
                              icon: Icon(
                                state.isPlaying == true
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 60,
                              ),
                              style: IconButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                            );
                          },
                        ),
                        const Gap(50),
                        IconButton(
                          onPressed: () {
                            _videoPlayerController.seekTo(
                              _videoPlayerController.value.position +
                                  const Duration(seconds: 10),
                            );
                            _controlsTimer.cancel();
                            _startCountdownToDismissControls();
                          },
                          icon: const Icon(
                            Icons.forward_10_rounded,
                            size: 60,
                          ),
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Header
            Positioned(
              top: 4,
              left: paddingSide,
              right: paddingSide,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: _controlsOverlayVisible
                    ? const Offset(0, 0)
                    : const Offset(0, -1),
                curve: Curves.easeInOut,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Platform.isIOS
                            ? Icons.arrow_back_ios_rounded
                            : Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Text(
                      widget.seasons[_currentSeasonIndex]
                          .episodes[_currentEpisodeIndex].title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(48)
                  ],
                ),
              ),
            ),
            //
            Positioned(
              bottom: 0,
              left: paddingSide,
              right: paddingSide,
              child: Column(
                children: [
                  // Video Progress Bart
                  AnimatedOpacity(
                    opacity: _controlsOverlayVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
                      builder: (ctx, state) {
                        final progress = state.progress;
                        return VideoProgressBar(
                          label: _convertFromSeconds(
                            (progress *
                                    _videoPlayerController
                                        .value.duration.inSeconds)
                                .toInt(),
                          ),
                          progress: progress,
                          remainingTime: _convertFromDuration(
                            _videoPlayerController.value.duration -
                                _videoPlayerController.value.position,
                          ),
                          onChangeStart: () async {
                            await _videoPlayerController.pause();
                            _controlsTimer.cancel();
                          },
                          onChanged: (value) => ctx
                              .read<VideoPlayerCubit>()
                              .setState(newProgress: value),
                          onChangeEnd: (value) async {
                            await _videoPlayerController.seekTo(
                              Duration(
                                milliseconds: (value *
                                        _videoPlayerController
                                            .value.duration.inMilliseconds)
                                    .toInt(),
                              ),
                            );
                            await _videoPlayerController.play();
                            _startCountdownToDismissControls();
                          },
                        );
                      },
                    ),
                  ),
                  // Bottom Utils
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 250),
                    offset: _controlsOverlayVisible
                        ? const Offset(0, 0)
                        : const Offset(0, 1),
                    curve: Curves.easeInOut,
                    child: Row(
                      children: [
                        const Gap(10),
                        TextButton.icon(
                          onPressed: () async {
                            _controlsTimer.cancel();
                            await showDialog(
                              context: context,
                              builder: (ctx) => VideoSpeedDialog(
                                currentSpeedOption:
                                    _videoPlayerController.value.playbackSpeed,
                                onChanged: (value) {
                                  if (value != null) {
                                    _videoPlayerController
                                        .setPlaybackSpeed(value);
                                    context.pop();
                                  }
                                },
                              ),
                            );
                            _startCountdownToDismissControls();
                          },
                          icon: const Icon(
                            Icons.speed_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: const Text('Tốc độ'),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white),
                        ),
                        const Gap(10),
                        if (!isMovie)
                          TextButton.icon(
                            onPressed: () async {
                              _controlsTimer.cancel();
                              _videoPlayerController.pause();
                              final Map<String, dynamic>? selectedEpisode =
                                  await showModalBottomSheet(
                                context: context,
                                builder: (ctx) => SeasonModalBottomSheet(
                                  seasons: widget.seasons,
                                  seasonsIndex: _currentSeasonIndex,
                                ),
                                /*
                                Gỡ bỏ giới hạn của chiều cao của BottomSheet
                                */
                                constraints: const BoxConstraints(
                                    maxWidth: double.infinity),
                                shape: const RoundedRectangleBorder(),
                                backgroundColor: Colors.black,
                                isScrollControlled: true,
                              );
                              /*
                              selectedEpisode là Tập phim được người dùng chọn để xem
                              */
                              if (selectedEpisode == null) {
                                _videoPlayerController.play();
                                _startCountdownToDismissControls();
                              } else {
                                // Chuyển sang xem tập phim này
                                _videoPlayerController.removeListener(
                                    _onVideoPlayerPositionChanged);
                                _videoPlayerController.dispose();

                                _currentSeasonIndex =
                                    selectedEpisode['season_index'];
                                _currentEpisodeIndex =
                                    selectedEpisode['episode_index'];

                                setVideoController(
                                  widget.seasons[_currentSeasonIndex]
                                      .episodes[_currentEpisodeIndex],
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.view_carousel_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            label: const Text('Các tập'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                          ),
                        const Gap(10),
                        if (!isLastEpisode)
                          TextButton.icon(
                            onPressed: () {
                              _videoPlayerController.removeListener(
                                  _onVideoPlayerPositionChanged);
                              _videoPlayerController.dispose();
                              if (_currentEpisodeIndex ==
                                  widget.seasons[_currentSeasonIndex].episodes
                                          .length -
                                      1) {
                                ++_currentSeasonIndex;
                                _currentEpisodeIndex = 0;
                                setVideoController(
                                  widget.seasons[_currentSeasonIndex]
                                      .episodes[_currentEpisodeIndex],
                                );
                              } else {
                                ++_currentEpisodeIndex;
                                setVideoController(
                                  widget.seasons[_currentSeasonIndex]
                                      .episodes[_currentEpisodeIndex],
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            label: const Text('Tập tiếp theo'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                          ),
                        const Gap(10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Brightness Screen Slider
            Positioned(
              right: paddingSide,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _controlsOverlayVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: BrightnessBar(
                  startCountdownToDismissControls:
                      _startCountdownToDismissControls,
                  cancelTimer: () => _controlsTimer.cancel(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _convertFromDuration(Duration duration) {
    int mins = duration.inMinutes;
    int secs = duration.inSeconds % 60;

    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _convertFromSeconds(int initalSeconds) {
    int mins = (initalSeconds ~/ 60);
    int secs = (initalSeconds % 60);
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
