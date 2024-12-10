import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail_cubit.dart';
import 'package:viovid_app/features/film_detail/data/cast_cache.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/film_detail/dtos/cast.dart';
import 'package:viovid_app/features/result_type.dart';

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

  bool _isLoading = false;
  final casts = <Cast>[];

  void _getCasts() async {
    final castsCache = context.read<CastCache>().casts;

    if (castsCache != null) {
      setState(() {
        casts.addAll(castsCache);
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result =
        await context.read<FilmDetailRepository>().getCasts(_film.filmId);

    switch (result) {
      case Success():
        casts.addAll(result.data);
        if (mounted) {
          context.read<CastCache>().casts = result.data;
        }
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
    _getCasts();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 254,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: _isLoading
          ? List.generate(12, (index) => const SkeletonLoading())
          : List.generate(
              casts.length,
              (index) => _buildCastItem(casts[index]),
            ),
    );
  }

  Widget _buildCastItem(Cast cast) {
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
    );
  }
}
