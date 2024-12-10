import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/features/film_detail/cubit/crews/crews_cubit.dart';
import 'package:viovid_app/features/film_detail/cubit/crews/crews_state.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/dtos/crew.dart';

class CrewTab extends StatefulWidget {
  const CrewTab({super.key});

  @override
  State<CrewTab> createState() => _CrewTabState();
}

class _CrewTabState extends State<CrewTab> {
  late final _filmDetailState = context.read<FilmDetailCubit>().state;
  late final _film = (switch (_filmDetailState) {
    FilmDetailSuccess() => _filmDetailState.film,
    _ => null,
  })!;

  @override
  void initState() {
    super.initState();
    final crewsCubit = context.read<CrewsCubit>();
    if (crewsCubit.state is CrewsInitial) {
      crewsCubit.getCrews(_film.filmId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrewsCubit, CrewsState>(
      buildWhen: (previous, current) =>
          current is CrewsSuccess || current is CrewsFailure,
      builder: (ctx, state) {
        if (state is CrewsFailure) {
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
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: state is CrewsSuccess
              ? List.generate(
                  state.crews.length,
                  (index) => _buildCastItem(state.crews[index]),
                )
              : List.generate(
                  12,
                  (index) => const SkeletonLoading(),
                ),
        );
      },
    );
  }

  Widget _buildCastItem(Crew crew) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
        border: Border.all(color: const Color.fromARGB(40, 255, 255, 255)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          crew.personProfilePath == null
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
                    crew.personProfilePath!,
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
                  crew.personName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  crew.role,
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
    );
  }
}
