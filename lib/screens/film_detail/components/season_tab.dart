import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/film_detail/data/season_cache.dart';
import 'package:viovid_app/features/film_detail/dtos/episode.dart';
import 'package:viovid_app/features/film_detail/dtos/season.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/screens/film_detail/components/horizontal_episode.dart';

class SeasonTab extends StatefulWidget {
  const SeasonTab({super.key});

  @override
  State<SeasonTab> createState() => _SeasonTabState();
}

class _SeasonTabState extends State<SeasonTab> {
  late final _filmDetailState = context.read<FilmDetailCubit>().state;
  late final _film = (switch (_filmDetailState) {
    FilmDetailSuccess() => _filmDetailState.film,
    _ => null,
  })!;

  int _selectedSeasonIndex = 0;
  final episodes = <Episode>[];

  bool _isLoading = false;

  Future<void> _getSeasonInfo() async {
    final seasonCache = context.read<SeasonCache>().seasons;

    final seasonId = _film.seasons[_selectedSeasonIndex].id;
    final episodeCache = seasonCache[seasonId];

    if (episodeCache != null) {
      setState(() {
        episodes.clear();
        episodes.addAll(episodeCache);
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await context.read<FilmDetailRepository>().getSeasonById(
          _film.filmId,
          seasonId,
        );

    switch (result) {
      case Success():
        episodes.clear();
        episodes.addAll(result.data.episodes);
        seasonCache[seasonId] = result.data.episodes;
        break;
      case Failure():
        // TODO: Handle Exception
        break;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSeasonInfo();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoading(width: 160, height: 24),
              Gap(8),
              SkeletonLoading(width: double.infinity, height: 198),
              Gap(14),
              SkeletonLoading(width: double.infinity, height: 198),
              Gap(14),
              SkeletonLoading(width: double.infinity, height: 198),
              Gap(14),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton(
                  padding: const EdgeInsets.only(left: 8),
                  value: _selectedSeasonIndex,
                  dropdownColor: const Color.fromARGB(255, 33, 33, 33),
                  style: GoogleFonts.montserrat(fontSize: 16),
                  isDense: true,
                  items: List.generate(
                    _film.seasons.length,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text(
                        _film.seasons[index].name,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null && value != _selectedSeasonIndex) {
                      setState(() {
                        _selectedSeasonIndex = value;
                      });
                      _getSeasonInfo();
                    }
                  },
                ),
              ),
              const Gap(8),
              ...episodes.map(
                (episode) {
                  // print('episode_id = ${e['id']}');
                  return HorizontalEpisode(
                    key: ValueKey(episode.id),
                    episode: episode,
                    // isEpisodeDownloaded:
                    //     widget.downloadedEpisodeIds.contains(e.episodeId),
                    // watchEpisode: () {
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (ctx) => MultiBlocProvider(
                    //         providers: [
                    //           BlocProvider(
                    //             create: (ctx) => VideoSliderCubit(),
                    //           ),
                    //           BlocProvider(
                    //             create: (ctx) => VideoPlayControlCubit(),
                    //           ),
                    //         ],
                    //         child: VideoPlayerView(
                    //           filmId: offlineData['film_id'],
                    //           seasons: widget.seasons,
                    //           downloadedEpisodeIds: widget.downloadedEpisodeIds,
                    //           firstEpisodeToPlay: e,
                    //           firstSeasonIndex: selectedSeason,
                    //         ),
                    //       ),
                    //     ),
                    //   );
                    // },
                  );
                },
              ),
            ],
          );
  }
}
