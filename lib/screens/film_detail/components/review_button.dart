import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/base/extension.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail/film_detail_cubit.dart';
import 'package:viovid_app/features/film_reviews/cubit/film_reviews_cutbit.dart';
import 'package:viovid_app/features/film_reviews/cubit/film_reviews_state.dart';
import 'package:viovid_app/features/film_reviews/dtos/review.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';

class ReviewButton extends StatefulWidget {
  const ReviewButton({super.key});

  @override
  State<ReviewButton> createState() => _ReviewButtonState();
}

class _ReviewButtonState extends State<ReviewButton> {
  late final _filmDetailState = context.read<FilmDetailCubit>().state;

  late final _film = (switch (_filmDetailState) {
    FilmDetailSuccess() => _filmDetailState.film,
    _ => null,
  })!;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (context.read<FilmReviewsCutbit>().state.reviews == null) {
          context.read<FilmReviewsCutbit>().getReviews(_film.filmId);
        }

        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFFFCE4E4),
          isScrollControlled: true,
          builder: (ctx) => BlocProvider.value(
            value: context.read<FilmReviewsCutbit>(),
            child: BlocBuilder<FilmReviewsCutbit, FilmReviewsState>(
              // bloc: context.read<FilmReviewsCutbit>(),
              builder: (context, state) {
                return ReviewsBottomSheet(
                  filmId: _film.filmId,
                  reviews: state.reviews ?? [],
                  isLoadingGetReviews: state.isLoadingGetReviews,
                  isLoadingPostReview: state.isLoadingPostReview,
                );
              },
            ),
          ),
        );
      },
      splashColor: Colors.amber,
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'Đánh giá phim',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ReviewsBottomSheet extends StatefulWidget {
  const ReviewsBottomSheet({
    super.key,
    required this.reviews,
    required this.isLoadingGetReviews,
    required this.isLoadingPostReview,
    required this.filmId,
  });

  final String filmId;
  final List<Review> reviews;
  final bool isLoadingGetReviews;
  final bool isLoadingPostReview;

  @override
  State<ReviewsBottomSheet> createState() => _ReviewsBottomSheetState();
}

class _ReviewsBottomSheetState extends State<ReviewsBottomSheet> {
  final _reviewsListKey = GlobalKey<AnimatedListState>();

  int _rate = 5;
  final _contentReviewController = TextEditingController();

  void postReview() async {
    if (_contentReviewController.text.isEmpty) {
      return;
    }
    await context.read<FilmReviewsCutbit>().postReview(
          widget.filmId,
          _rate,
          _contentReviewController.text,
        );

    _contentReviewController.clear();
  }

  @override
  void didUpdateWidget(covariant ReviewsBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.reviews != oldWidget.reviews) {
      _reviewsListKey.currentState?.insertItem(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.read<UserProfileCubit>().state.userProfile;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        21,
        40,
        5,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: widget.isLoadingGetReviews
          ? const SizedBox(
              width: double.infinity,
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      "ĐÁNH GIÁ   ●   ${widget.reviews.length} lượt",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
                Expanded(
                  child: widget.reviews.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Chưa có nhận xét nào'),
                              Text('Hãy là người đánh giá đầu tiên'),
                            ],
                          ),
                        )
                      : AnimatedList(
                          key: _reviewsListKey,
                          initialItemCount: widget.reviews.length,
                          itemBuilder: (ctx, index, animation) =>
                              SizeTransition(
                            sizeFactor: animation,
                            child: _buildReviewItem(context, index),
                          ),
                        ),
                ),
                Divider(
                  endIndent: 16,
                  color: Theme.of(context).colorScheme.primary.withAlpha(80),
                  height: 30,
                ),
                if (userProfile != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CachedNetworkImage(
                            imageUrl: userProfile.avatar,
                            fit: BoxFit.cover,
                            // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
                            fadeInDuration: const Duration(milliseconds: 400),
                            // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
                            fadeOutDuration: const Duration(milliseconds: 800),
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                strokeCap: StrokeCap.round,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Gap(14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProfile.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            _buildStarRate(),
                          ],
                        ),
                      ),
                      const Gap(14),
                      IconButton.filled(
                        onPressed:
                            widget.isLoadingPostReview ? null : postReview,
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        icon: widget.isLoadingPostReview
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeCap: StrokeCap.round,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.arrow_upward_rounded),
                      ),
                      const Gap(12),
                    ],
                  ),
                const Gap(6),
                TextFormField(
                  controller: _contentReviewController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Bình luận của bạn',
                    hintStyle: TextStyle(color: Color(0xFFACACAC)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                  ),
                  style: const TextStyle(color: Colors.black),
                  autocorrect: false,
                  enableSuggestions: false, // No work
                  keyboardType:
                      TextInputType.emailAddress, // Trick: disable suggestions
                  validator: (value) {
                    // print('Value = $value');
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập Email';
                    }
                    return null;
                  },
                ),
                if (Platform.isAndroid) const Gap(14)
              ],
            ),
    );
  }

  Widget _buildReviewItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 65,
              height: 65,
              child: CachedNetworkImage(
                imageUrl: widget.reviews[index].userAvatar,
                fit: BoxFit.cover,
                // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
                fadeInDuration: const Duration(milliseconds: 400),
                // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
                fadeOutDuration: const Duration(milliseconds: 800),
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.reviews[index].userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.reviews[index].createAt.toVnFormat(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.reviews[index].start,
                    (index) => Icon(
                      Icons.star_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Text(
                  widget.reviews[index].content,
                )
              ],
            ),
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _buildStarRate() {
    return StatefulBuilder(
      builder: (ctx, setStateRate) {
        return Row(
          children: List.generate(
            5,
            (index) => InkWell(
              onTap: () {
                setStateRate(() => _rate = index + 1);
              },
              borderRadius: BorderRadius.circular(20),
              child: Icon(
                index + 1 <= _rate
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
