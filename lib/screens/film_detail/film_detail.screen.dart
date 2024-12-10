import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/base/extension.dart';
import 'package:viovid_app/features/film_detail/cubit/casts/casts_cubit.dart';
import 'package:viovid_app/features/film_detail/cubit/crews/crews_cubit.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/film_detail/data/season_cache.dart';
import 'package:viovid_app/features/film_detail/dtos/film.dart';
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
          FavoriteButton(
            filmId: widget.filmId,
            isAlreadyInMyList: false,
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
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
                SizedBox(
                  width: double.infinity,
                  child: IconButton.filled(
                    onPressed: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (ctx) => MultiBlocProvider(
                      //       providers: [
                      //         BlocProvider(
                      //           create: (ctx) => VideoSliderCubit(),
                      //         ),
                      //         BlocProvider(
                      //           create: (ctx) => VideoPlayControlCubit(),
                      //         ),
                      //       ],
                      //       child: VideoPlayerView(
                      //         filmId: film.id,
                      //         seasons: film.seasons,
                      //         downloadedEpisodeIds: _downloadedEpisodeIds,
                      //         firstEpisodeToPlay: film.seasons[0].episodes[0],
                      //         firstSeasonIndex: 0,
                      //       ),
                      //     ),
                      //   ),
                      // );
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
          RepositoryProvider(
            create: (ctx) => SeasonCache(),
            child: MultiBlocProvider(
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
            ),
          ),
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
