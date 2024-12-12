import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:viovid_app/config/app_route.dart';
import 'package:viovid_app/features/topic/dtos/topic.dart';

class ContentList extends StatelessWidget {
  const ContentList({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final isBigger = topic.order == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, top: 16, bottom: 6),
          child: Text(
            topic.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: isBigger ? 360 : 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) {
              final film = topic.films[index];
              return GestureDetector(
                onTap: () async {
                  context.push(
                    RouteName.filmDetail.replaceFirst(':id', film.filmId),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isBigger ? 240 : 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(imageUrl: film.posterPath),
                ),
              );
            },
            itemCount: topic.films.length,
          ),
        )
      ],
    );
  }
}
