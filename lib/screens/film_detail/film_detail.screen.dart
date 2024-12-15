import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/base/extension.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/film_detail/cubit/casts/casts_cubit.dart';
import 'package:viovid_app/features/film_detail/cubit/crews/crews_cubit.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/film_detail/dtos/film.dart';
import 'package:viovid_app/features/my_list/cubit/my_list_cubit.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_state.dart';
import 'package:viovid_app/features/user_profile/dtos/tracking_progress.dart';
import 'package:viovid_app/screens/film_detail/components/bottom_tabs.dart';
import 'package:viovid_app/screens/film_detail/components/favorite_button.dart';

class FilmDetailScreen extends StatefulWidget {
  const FilmDetailScreen({
    super.key,
    required this.filmId,
  });

  final String filmId;

  @override
  State<FilmDetailScreen> createState() => _FilmDetailScreenState();
}

class _FilmDetailScreenState extends State<FilmDetailScreen> {
  bool _isExpandOverview = false;

  @override
  void initState() {
    super.initState();
    context.read<FilmDetailCubit>().getFilmDetail(widget.filmId);
  }

  @override
  Widget build(BuildContext context) {
    final filmDetailState = context.watch<FilmDetailCubit>().state;

    var filmDetailWidget = (switch (filmDetailState) {
      FilmDetailInProgress() => _buildInProgressFilmDetailWidget(),
      FilmDetailSuccess() => _buildFilmDetailWidget(filmDetailState.film),
      FilmDetailFailure() =>
        _buildFailureFilmDetailWidget(filmDetailState.message),
    });

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Assets.viovidLogo,
          width: 120,
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        actions: [
          BlocListener<MyListCubit, MyListState>(
            listenWhen: (previous, current) =>
                current is MyListSuccess || current is MyListFailure,
            listener: (ctx, state) {
              if (state is MyListSuccess) {
                ScaffoldMessenger.of(context).clearSnackBars();
                final isInMyList =
                    state.films.any((film) => film.filmId == widget.filmId);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: isInMyList
                        ? const Text('Đã thêm vào Danh sách của tôi')
                        : const Text('Đã xoá vào Danh sách của tôi'),
                    duration: const Duration(seconds: 3),
                    action: isInMyList
                        ? SnackBarAction(
                            label: 'Xem',
                            textColor: Colors.amber,
                            onPressed: () => context.push(RouteName.myList),
                          )
                        : null,
                  ),
                );
              }
              // TODO: Show popup dialog when current state is MyListFailure,
            },
            child: BlocBuilder<MyListCubit, MyListState>(
              builder: (ctx, state) {
                if (state is MyListInProgress) {
                  return const SizedBox(
                    width: 48,
                    height: 48,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        color: Colors.white54,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                }

                if (state is MyListSuccess) {
                  return FavoriteButton(
                    filmId: widget.filmId,
                    isAlreadyInMyList: state.films.any(
                      (film) => film.filmId == widget.filmId,
                    ),
                  );
                }

                return const SizedBox(width: 48);
              },
            ),
          ),
        ],
      ),
      body: filmDetailWidget,
    );
  }

  Widget _buildInProgressFilmDetailWidget() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Gap(14),
          Text(
            'Đang tải dữ liệu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilmDetailWidget(Film film) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: film.overview,
        style: const TextStyle(color: Colors.white),
      ),
      maxLines: 4,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: MediaQuery.sizeOf(context).width,
      );
    final isOverflowed = textPainter.didExceedMaxLines;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                film.backdropPath,
                width: double.infinity,
                height: 9 / 16 * MediaQuery.sizeOf(context).width,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.black,
                        border: Border.all(
                          width: 1,
                          color: Colors.white,
                        ),
                      ),
                      child: Text(
                        film.contentRating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (film.seasons[0].name == '')
                      BlocBuilder<UserProfileCubit, UserProfileState>(
                        buildWhen: (previous, current) =>
                            current.userTrackingProgress?[
                                film.seasons[0].episodes[0].id] !=
                            null,
                        builder: (context, state) {
                          final episode = film.seasons[0].episodes[0];
                          final currentProgress =
                              state.userTrackingProgress?[episode.id] ?? 0;
                          return Positioned(
                            bottom: 4,
                            left: 4,
                            right: 4,
                            child: LinearProgressIndicator(
                              value: currentProgress / episode.duration,
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2),
                              backgroundColor: Colors.white54,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  film.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Phát hành: ${film.releaseDate.toVnFormat()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // StatefulBuilder(builder: (ctx, setStateVoteAverage) {
                //   return Row(
                //     children: [
                //       Text(
                //         voteAverage == 0
                //             ? 'Chưa có đánh giá'
                //             : 'Điểm: ${voteAverage.toStringAsFixed(2)}',
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       const Spacer(),
                //       InkWell(
                //         onTap: () {
                //           showModalBottomSheet(
                //             context: context,
                //             builder: (ctx) => ReviewsBottomSheet(
                //               reviews: film.reviews,
                //               onReviewHasChanged: () {
                //                 setStateVoteAverage(() {
                //                   voteAverage = film.reviews.fold(
                //                           0,
                //                           (previousValue, review) =>
                //                               previousValue + review.star) /
                //                       film.reviews.length;
                //                 });
                //               },
                //             ),
                //             /*
                //                         Gỡ bỏ giới hạn của chiều cao của BottomSheet
                //                         */
                //             isScrollControlled: true,
                //             // Không hoạt động useSafeArea
                //             // useSafeArea: true,
                //           );
                //         },
                //         borderRadius: BorderRadius.circular(8),
                //         child: Container(
                //           padding:
                //               const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(8),
                //             color: Colors.white30,
                //           ),
                //           child: const Text(
                //             'Xem chi tiết',
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   );
                // }),
                const SizedBox(height: 12),
                // isMovie
                if (film.seasons[0].name == '')
                  SizedBox(
                    width: double.infinity,
                    child: IconButton.filled(
                      onPressed: () async {
                        final TrackingProgress? trackingProgress =
                            await context.push(
                          '${GoRouterState.of(context).uri}/watching',
                          extra: {
                            'filmName': film.name,
                            'seasons': film.seasons,
                            'firstEpisodeIdToPlay':
                                film.seasons[0].episodes[0].id,
                            'initProgress': context
                                    .read<UserProfileCubit>()
                                    .state
                                    .userTrackingProgress?[
                                film.seasons[0].episodes[0].id]
                          },
                        );

                        if (trackingProgress != null) {
                          // ignore: use_build_context_synchronously
                          context
                              .read<UserProfileCubit>()
                              .updateTrackingProgress(trackingProgress);
                        }
                      },
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 32,
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                // if (isMovie)
                //   DownloadButton(
                //     firstEpisodeId: film.seasons[0].episodes[0].episodeId,
                //     firstEpisodeLink: film.seasons[0].episodes[0].linkEpisode,
                //     runtime: film.seasons[0].episodes[0].runtime,
                //     isEpisodeDownloaded: _downloadedEpisodeIds
                //         .contains(film.seasons[0].episodes[0].episodeId),
                //   ),
                const SizedBox(height: 6),
                Text(
                  film.overview,
                  style: const TextStyle(color: Colors.white),
                  maxLines: _isExpandOverview ? null : 4,
                  textAlign: TextAlign.justify,
                ),
                if (isOverflowed)
                  InkWell(
                    onTap: () => setState(() {
                      _isExpandOverview = !_isExpandOverview;
                    }),
                    child: Text(
                      _isExpandOverview ? 'Ẩn bớt' : 'Xem thêm',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Thể loại:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // final genreId = film.genres[0].id;
                        // TODO: Navigate to Genre Screen
                      },
                      child: Text(
                        film.genres[0].name,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    for (int i = 1; i < film.genres.length; ++i)
                      GestureDetector(
                        onTap: () {
                          // final genreId = film.genres[i].id;
                          // TODO: Navigate to Genre Screen
                        },
                        child: Text(
                          ', ${film.genres[i].name}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (ctx) => CastsCubit(
                  ctx.read<FilmDetailRepository>(),
                ),
              ),
              BlocProvider(
                create: (ctx) => CrewsCubit(
                  ctx.read<FilmDetailRepository>(),
                ),
              ),
            ],
            child: const BottomTabs(),
          )
        ],
      ),
    );
  }

  Widget buildSegment(String text) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFailureFilmDetailWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
