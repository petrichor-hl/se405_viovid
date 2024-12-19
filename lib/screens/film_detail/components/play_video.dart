import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/features/user_profile/dtos/tracking_progress.dart';
import 'package:viovid_app/screens/film_detail/components/promote_dialog.dart';

class PlayVideoButton extends StatelessWidget {
  const PlayVideoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final filmDetailState = context.read<FilmDetailCubit>().state;
    final film = (switch (filmDetailState) {
      FilmDetailSuccess() => filmDetailState.film,
      _ => null,
    })!;

    return IconButton.filled(
      onPressed: () async {
        if (!film.seasons[0].episodes[0].isFree &&
            context.read<UserProfileCubit>().checkNormalUser()) {
          await showDialog(
            context: context,
            builder: (ctx) => const PromoteDialog(),
          );
          return;
        }

        final TrackingProgress? trackingProgress = await context.push(
          '${GoRouterState.of(context).uri}/watching',
          extra: {
            'filmName': film.name,
            'seasons': film.seasons,
            'firstEpisodeIdToPlay': film.seasons[0].episodes[0].id,
            'initProgress': context
                .read<UserProfileCubit>()
                .state
                .userTrackingProgress?[film.seasons[0].episodes[0].id]
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
    );
  }
}
