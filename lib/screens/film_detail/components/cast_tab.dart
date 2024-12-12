import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/film_detail/cubit/casts/casts_cubit.dart';
import 'package:viovid_app/features/film_detail/cubit/casts/casts_state.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/dtos/cast.dart';

class CastTab extends StatefulWidget {
  const CastTab({super.key});

  @override
  State<CastTab> createState() => _CastTabState();
}

class _CastTabState extends State<CastTab> {
  late final _filmDetailState = context.read<FilmDetailCubit>().state;
  late final _film = (switch (_filmDetailState) {
    FilmDetailSuccess() => _filmDetailState.film,
    _ => null,
  })!;

  @override
  void initState() {
    super.initState();
    final castsCubit = context.read<CastsCubit>();
    if (castsCubit.state is CastsInitial) {
      castsCubit.getCasts(_film.filmId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CastsCubit, CastsState>(
      buildWhen: (previous, current) =>
          current is CastsSuccess || current is CastsFailure,
      builder: (ctx, state) {
        if (state is CastsFailure) {
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
            mainAxisExtent: 254,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          children: state is CastsSuccess
              ? List.generate(
                  state.casts.length,
                  (index) => _buildCastItem(state.casts[index]),
                )
              : List.generate(
                  12,
                  (index) => const SkeletonLoading(),
                ),
        );
      },
    );
  }

  Widget _buildCastItem(Cast cast) {
    return InkWell(
      onTap: () => context.push(
        RouteName.person.replaceFirst(':id', cast.personId),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.black,
          border: Border.all(color: const Color.fromARGB(40, 255, 255, 255)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cast.personProfilePath == null
                ? const SizedBox(
                    height: 155,
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(
                      cast.personProfilePath!,
                      width: double.infinity, // minus border's width = 1
                      height: 155,
                      fit: BoxFit.cover,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cast.personName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    cast.character,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
