import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/film_detail/dtos/season.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/screens/film_detail/components/horizontal_episode.dart';

class EpisodeTab extends StatefulWidget {
  const EpisodeTab({super.key});

  @override
  State<EpisodeTab> createState() => _EpisodeTabState();
}

class _EpisodeTabState extends State<EpisodeTab> {
  late final _filmDetailState = context.read<FilmDetailCubit>().state;
  late final _film = (switch (_filmDetailState) {
    FilmDetailSuccess() => _filmDetailState.film,
    _ => null,
  })!;

  final Map<int, Season> seasonCache = {};
  int _selectedSeasonIndex = 0;

  bool _isLoading = true;

  Future<void> _getSeasonInfo() async {
    if (seasonCache.containsKey(_selectedSeasonIndex)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final seasonId = _film.seasons[_selectedSeasonIndex].id;

    final result = await context.read<FilmDetailRepository>().getSeasonById(
          _film.filmId,
          seasonId,
        );

    setState(() {
      _isLoading = false;
    });

    switch (result) {
      case Success():
        seasonCache[_selectedSeasonIndex] = result.data;
        break;
      case Failure():
        // TODO: Handle Exception
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getSeasonInfo();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 8),
                child: DropdownButton(
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
              const SizedBox(height: 12),
              ...?seasonCache[_selectedSeasonIndex]?.episodes.map(
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
