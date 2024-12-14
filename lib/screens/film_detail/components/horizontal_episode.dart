import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/dtos/episode.dart';

class HorizontalEpisode extends StatelessWidget {
  const HorizontalEpisode({super.key, required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final filmDetailState = context.read<FilmDetailCubit>().state;
    final film = (switch (filmDetailState) {
      FilmDetailSuccess() => filmDetailState.film,
      _ => null,
    })!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () {
          context.push(
            '${GoRouterState.of(context).uri}/watching',
            extra: {
              'filmName': film.name,
              'seasons': film.seasons,
              'firstEpisodeIdToPlay': film.seasons[0].episodes[0].id,
            },
          );
        },
        splashColor: const Color.fromARGB(255, 52, 52, 52),
        // borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      episode.stillPath,
                      height: 80,
                      width: 143,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            episode.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${episode.duration} phút',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16)
                ],
              ),
              const Gap(8),
              Text(
                episode.summary,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
