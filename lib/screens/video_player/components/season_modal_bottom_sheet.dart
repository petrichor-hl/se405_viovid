import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/features/film_detail/dtos/episode.dart';
import 'package:viovid_app/features/film_detail/dtos/season.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';
import 'package:viovid_app/screens/film_detail/components/promote_dialog.dart';

class SeasonModalBottomSheet extends StatefulWidget {
  const SeasonModalBottomSheet({
    super.key,
    required this.seasons,
    required this.seasonsIndex,
  });

  final List<Season> seasons;
  final int seasonsIndex;

  @override
  State<SeasonModalBottomSheet> createState() => _SeasonModalBottomSheetState();
}

class _SeasonModalBottomSheetState extends State<SeasonModalBottomSheet> {
  late int currentSeasonIndex = widget.seasonsIndex;

  @override
  Widget build(BuildContext context) {
    final episodes = widget.seasons[currentSeasonIndex].episodes;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                ),
                const Spacer(),
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  offset: const Offset(0, 4),
                  itemBuilder: (ctx) => List.generate(
                    widget.seasons.length,
                    (index) => PopupMenuItem(
                      onTap: () {
                        setState(() {
                          currentSeasonIndex = index;
                        });
                      },
                      child: Text(
                        widget.seasons[index].name,
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
                          widget.seasons[currentSeasonIndex].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap(4),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) => _EpisodeItem(
                  episode: episodes[index],
                  // seasonIndex là số thứ tự season chứa tập phim này
                  seasonIndex: currentSeasonIndex,
                  episodeIndex: index,
                ),
                itemCount: episodes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EpisodeItem extends StatelessWidget {
  const _EpisodeItem({
    required this.episode,
    required this.seasonIndex,
    required this.episodeIndex,
  });

  final Episode episode;
  final int seasonIndex;
  final int episodeIndex;

  @override
  Widget build(BuildContext context) {
    final isNormalUser =
        context.read<UserProfileCubit>().state.userProfile?.planName ==
            "Normal";

    return Ink(
      padding: const EdgeInsets.only(right: 10),
      width: 227,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () async {
          if (!episode.isFree && isNormalUser) {
            await showDialog(
              context: context,
              builder: (ctx) => const PromoteDialog(),
            );
            return;
          }

          context.pop({
            'season_index': seasonIndex,
            'episode_index': episodeIndex,
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xFF333333),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    episode.stillPath,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              height: 127,
              child: const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const Gap(6),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isNormalUser)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: episode.isFree ? Colors.green : Colors.amber,
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
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: Text(
                episode.summary,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
