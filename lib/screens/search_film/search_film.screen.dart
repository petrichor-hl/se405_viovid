import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/search_film/cubit/search_film_cubit.dart';
import 'package:viovid_app/features/search_film/cubit/search_film_state.dart';

class SearchFilmScreen extends StatefulWidget {
  const SearchFilmScreen({super.key});

  @override
  State<SearchFilmScreen> createState() => _SearchFilmScreenState();
}

class _SearchFilmScreenState extends State<SearchFilmScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchFilmCubit, SearchFilmState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        Widget childWidget = const SizedBox();

        if (state.isLoading) {
          childWidget = const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Gap(14),
              Text(
                'Đang tìm kiếm ...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Gap(40),
            ],
          );
        } else if (state.films == null) {
          childWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/decor_image.png',
                width: MediaQuery.sizeOf(context).width * 0.6,
              ),
              const Gap(16),
              const Text(
                'Tìm bộ phim yêu thích của bạn',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const Gap(40),
            ],
          );
        } else if (state.films!.isEmpty) {
          childWidget = const Center(
            child: Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          );
        } else if (state.films!.isNotEmpty) {
          final films = state.films!;
          childWidget = GridView(
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(8),
            children: List.generate(
              films.length,
              (index) => InkWell(
                onTap: () => context.push(
                  RouteName.filmDetail.replaceFirst(':id', films[index].filmId),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: films[index].posterPath,
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF2B2B2B),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                  ),
                  prefixIconColor: Colors.white54,
                  hintText: 'Tìm kiếm bộ phim của bạn',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 120, 120, 120),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 14),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                autocorrect: false,
                textInputAction: TextInputAction.search,
                onEditingComplete: () {
                  // TODO:
                  log('searching ...');
                  context
                      .read<SearchFilmCubit>()
                      .searchFilm(_searchController.text);
                  FocusScope.of(context).unfocus();
                },
              ),
              Expanded(
                child: childWidget,
              ),
            ],
          ),
        );
      },
    );
  }
}
