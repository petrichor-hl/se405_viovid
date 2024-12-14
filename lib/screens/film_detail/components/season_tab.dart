import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
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

  int _currentSeasonIndex = 0;

  @override
  void initState() {
    super.initState();
    // _getSeasonInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: PopupMenuButton(
                position: PopupMenuPosition.under,
                offset: const Offset(0, 4),
                itemBuilder: (ctx) => List.generate(
                  _film.seasons.length,
                  (index) => PopupMenuItem(
                    onTap: () {
                      setState(() {
                        _currentSeasonIndex = index;
                      });
                    },
                    child: Text(
                      _film.seasons[index].name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFF333333),
                tooltip: '',
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    spacing: 4,
                    children: [
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      Text(
                        _film.seasons[_currentSeasonIndex].name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        ..._film.seasons[_currentSeasonIndex].episodes.map(
          (episode) {
            // print('episode_id = ${e['id']}');
            return HorizontalEpisode(
              key: ValueKey(episode.id),
              episode: episode,
            );
          },
        ),
      ],
    );
  }
}
