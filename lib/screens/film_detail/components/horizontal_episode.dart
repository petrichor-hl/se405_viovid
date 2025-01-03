import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/film_detail/dtos/episode.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_state.dart';
import 'package:viovid_app/features/user_profile/dtos/tracking_progress.dart';
import 'package:viovid_app/screens/film_detail/components/promote_dialog.dart';

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

    final isNormalUser =
        context.read<UserProfileCubit>().state.userProfile?.planName ==
            "Normal";

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () async {
          if (!episode.isFree && isNormalUser) {
            await showDialog(
              context: context,
              builder: (ctx) => const PromoteDialog(),
            );
            return;
          }

          context.read<FilmDetailRepository>().countView(film.filmId);

          final TrackingProgress? trackingProgress = await context.push(
            '${GoRouterState.of(context).uri}/watching',
            extra: {
              'filmName': film.name,
              'seasons': film.seasons,
              'firstEpisodeIdToPlay': episode.id,
              'initProgress': context
                  .read<UserProfileCubit>()
                  .state
                  .userTrackingProgress?[episode.id]
            },
          );

          if (trackingProgress != null) {
            // ignore: use_build_context_synchronously
            context
                .read<UserProfileCubit>()
                .updateTrackingProgress(trackingProgress);
          }
        },
        splashColor: const Color.fromARGB(255, 52, 52, 52),
        // borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl: episode.stillPath,
                          height: 80,
                          width: 143,
                          fit: BoxFit.cover,
                        ),
                      ),
                      BlocBuilder<UserProfileCubit, UserProfileState>(
                        buildWhen: (previous, current) =>
                            current.userTrackingProgress?[episode.id] != null,
                        builder: (context, state) {
                          final currentProgress =
                              state.userTrackingProgress?[episode.id] ?? 0;
                          return Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  episode.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isNormalUser)
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: episode.isFree
                                        ? Colors.green
                                        : Colors.amber,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      episode.isFree ? "Miễn phí" : "Trả phí",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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
