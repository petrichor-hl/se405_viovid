import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/config/api.config.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/film_detail/dtos/genre.dart';

class GenreListDrawer extends StatefulWidget {
  const GenreListDrawer({super.key});

  @override
  State<GenreListDrawer> createState() => _GenreListDrawerState();
}

class _GenreListDrawerState extends State<GenreListDrawer> {
  late final List<Genre> genres;

  Future<void> _fetchGenres() async {
    genres = await ApiClient(dio).request<void, List<Genre>>(
      url: '/Genre',
      method: ApiMethod.get,
      fromJson: (resultJson) =>
          (resultJson as List).map((genre) => Genre.fromJson(genre)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 286,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Xóa bo góc
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            color: Colors.black,
            width: 258,
            child: FutureBuilder(
              future: _fetchGenres(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Truy xuất danh sách Thể loại thất bại',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }

                return SafeArea(
                  child: ListView(
                    children: List.generate(
                      genres.length,
                      (index) => ListTile(
                        onTap: () => context.push(
                          RouteName.genre.replaceFirst(':id', genres[index].id),
                          extra: {
                            "genre_name": genres[index].name,
                          },
                        ),
                        title: Text(
                          genres[index].name,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton.filled(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 32,
                ),
                style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
