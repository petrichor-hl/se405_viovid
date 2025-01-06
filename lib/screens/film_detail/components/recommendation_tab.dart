import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/cubit/recommendations/recommendations_cubit.dart';
import 'package:viovid_app/features/film_detail/cubit/recommendations/recommendations_state.dart';

class RecommendationTab extends StatefulWidget {
  const RecommendationTab({super.key});

  @override
  State<RecommendationTab> createState() => _RecommendationTabState();
}

class _RecommendationTabState extends State<RecommendationTab> {
  late final _filmDetailState = context.read<FilmDetailCubit>().state;
  late final _film = (switch (_filmDetailState) {
    FilmDetailSuccess() => _filmDetailState.film,
    _ => null,
  })!;

  @override
  void initState() {
    super.initState();
    final recommendationsCubit = context.read<RecommendationsCubit>();
    if (recommendationsCubit.state is RecommendationsInitial) {
      String type = _film.seasons[0].name == '' ? 'movie' : 'tv';
      recommendationsCubit.getRecommendations(type, _film.tmdbId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationsCubit, RecommendationsState>(
      buildWhen: (previous, current) =>
          current is RecommendationsSuccess ||
          current is RecommendationsFailure,
      builder: (ctx, state) {
        if (state is RecommendationsFailure) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        }

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(8),
          children: state is RecommendationsSuccess
              ? List.generate(
                  state.films.length,
                  (index) => ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: state.films[index].posterPath,
                        ),
                      ))
              : List.generate(
                  12,
                  (index) => const SkeletonLoading(),
                ),
        );

        // return GridView(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 3,
        //     mainAxisExtent: 254,
        //     crossAxisSpacing: 8,
        //     mainAxisSpacing: 8,
        //   ),
        //   children: state is RecommendationsSuccess
        //       ? List.generate(
        //           state.films.length,
        //           (index) =>
        //               _buildRecommendationItem(state.films[index]),
        //         )
        //       : List.generate(
        //           12,
        //           (index) => const SkeletonLoading(),
        //         ),
        // );
      },
    );
  }

  // Widget _buildRecommendationItem(SimpleFilm film) {
  //   return InkWell(
  //     onTap: () => context.push(
  //       RouteName.person.replaceFirst(':id', cast.personId),
  //     ),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(4),
  //         color: Colors.black,
  //         border: Border.all(color: const Color.fromARGB(40, 255, 255, 255)),
  //       ),
  //       clipBehavior: Clip.antiAlias,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           cast.personProfilePath == null
  //               ? const SizedBox(
  //                   height: 155,
  //                   child: Center(
  //                     child: Icon(
  //                       Icons.person_rounded,
  //                       color: Colors.grey,
  //                       size: 48,
  //                     ),
  //                   ),
  //                 )
  //               : ClipRRect(
  //                   borderRadius: BorderRadius.circular(7),
  //                   child: Image.network(
  //                     cast.personProfilePath!,
  //                     width: double.infinity, // minus border's width = 1
  //                     height: 155,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //           Padding(
  //             padding: const EdgeInsets.all(8),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   cast.personName,
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 Text(
  //                   cast.character,
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                   ),
  //                   maxLines: 2,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
