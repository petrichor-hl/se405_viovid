import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/film_reviews/dtos/post_review_dto.dart';
import 'package:viovid_app/features/film_reviews/dtos/review.dart';

class FilmReviewsApiService {
  FilmReviewsApiService(this.dio);

  final Dio dio;

  Future<List<Review>> getReviews(String filmId) async {
    try {
      return await ApiClient(dio).request<void, List<Review>>(
        url: '/Film/$filmId/reviews',
        method: ApiMethod.get,
        fromJson: (resultJson) => (resultJson as List)
            .map((review) => Review.fromJson(review))
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<Review> postReview(
    String filmId,
    PostReviewDto postReviewDto,
  ) async {
    try {
      return await ApiClient(dio).request<PostReviewDto, Review>(
        url: '/Film/$filmId/reviews',
        method: ApiMethod.post,
        payload: postReviewDto,
        fromJson: (resultJson) => Review.fromJson(resultJson),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['Errors'][0]['Message']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
