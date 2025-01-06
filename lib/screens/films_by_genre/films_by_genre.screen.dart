import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/base/components/skeleton_loading.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/films_by_genre/cubit/films_by_genre_cubit.dart';

class FilmsByGenreScreen extends StatefulWidget {
  const FilmsByGenreScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  final String genreId;
  final String genreName;

  @override
  State<FilmsByGenreScreen> createState() => _FilmsByGenreScreennState();
}

class _FilmsByGenreScreennState extends State<FilmsByGenreScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FilmsByGenreCubit>().getGenreWithFilms(widget.genreId);
  }

  @override
  Widget build(BuildContext context) {
    final filmsByGenreState = context.watch<FilmsByGenreCubit>().state;

    if (filmsByGenreState is FilmsByGenreFailure) {
      return _buildFailureFilmsByGenreWidget(filmsByGenreState.message);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.genreName),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding: const EdgeInsets.all(8),
        children: filmsByGenreState is FilmsByGenreSuccess
            ? List.generate(
                filmsByGenreState.genre.films.length,
                (index) => InkWell(
                  onTap: () => context.push(
                    RouteName.filmDetail.replaceFirst(
                        ':id', filmsByGenreState.genre.films[index].filmId),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: filmsByGenreState.genre.films[index].posterPath,
                    ),
                  ).animate().fade().scale(),
                ),
              )
            : List.generate(
                12,
                (index) => const SkeletonLoading(),
              ),
      ),
    );
  }

  Widget _buildFailureFilmsByGenreWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
