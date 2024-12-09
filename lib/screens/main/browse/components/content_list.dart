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
          padding: const EdgeInsets.only(left: 20, top: 16, bottom: 6),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    topic.order == 1
                        ? 'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${film.posterPath}'
                        : 'https://image.tmdb.org/t/p/w440_and_h660_face/${film.posterPath}',
                    fit: BoxFit.cover,
                    // https://api.flutter.dev/flutter/widgets/Image/frameBuilder.html
                    frameBuilder: (
                      BuildContext context,
                      Widget child,
                      int? frame,
                      bool wasSynchronouslyLoaded,
                    ) {
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(
                          milliseconds: 500,
                        ), // Adjust the duration as needed
                        curve: Curves.easeInOut,
                        child: child, // Adjust the curve as needed
                      );
                    },
                    // https://api.flutter.dev/flutter/widgets/Image/loadingBuilder.html
                    loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: SizedBox(
                          width: isBigger ? 48 : 36,
                          height: isBigger ? 48 : 36,
                          child: const CircularProgressIndicator(
                            // value: loadingProgress.expectedTotalBytes != null
                            //     ? loadingProgress.cumulativeBytesLoaded /
                            //         loadingProgress.expectedTotalBytes!
                            //     : null,
                            color: Colors.grey,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                      );
                    },
                  ),
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
