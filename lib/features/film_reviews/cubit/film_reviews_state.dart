import 'package:viovid_app/features/film_reviews/dtos/review.dart';

class FilmReviewsState {
  final List<Review>? reviews;
  final bool isLoadingGetReviews;
  final bool isLoadingPostReview;
  final String errorMessage;

  FilmReviewsState({
    this.reviews,
    this.isLoadingGetReviews = false,
    this.isLoadingPostReview = false,
    this.errorMessage = "",
  });

  FilmReviewsState copyWith({
    List<Review>? reviews,
    bool? isLoadingGetReviews,
    bool? isLoadingPostReview,
    String? errorMessage,
  }) {
    return FilmReviewsState(
      reviews: reviews ?? this.reviews,
      isLoadingGetReviews: isLoadingGetReviews ?? this.isLoadingGetReviews,
      isLoadingPostReview: isLoadingPostReview ?? this.isLoadingPostReview,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
