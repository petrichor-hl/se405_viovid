import 'package:viovid_app/features/film_reviews/data/film_reviews_api_service.dart';
import 'package:viovid_app/features/film_reviews/dtos/post_review_dto.dart';
import 'package:viovid_app/features/film_reviews/dtos/review.dart';
import 'package:viovid_app/features/result_type.dart';

class FilmReviewsRepository {
  final FilmReviewsApiService filmReviewsApiService;

  FilmReviewsRepository({
    required this.filmReviewsApiService,
  });

  Future<Result<List<Review>>> getReviews(String filmId) async {
    try {
      return Success(await filmReviewsApiService.getReviews(filmId));
    } catch (error) {
      return Failure('$error');
    }
  }

  Future<Result<Review>> postReview(
    String filmId,
    int start,
    String content,
  ) async {
    try {
      return Success(
        await filmReviewsApiService.postReview(
          filmId,
          PostReviewDto(start: start, content: content),
        ),
      );
    } catch (error) {
      return Failure('$error');
    }
  }
}
