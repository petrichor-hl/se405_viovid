import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/film_reviews/cubit/film_reviews_state.dart';
import 'package:viovid_app/features/film_reviews/data/film_reviews_repository.dart';
import 'package:viovid_app/features/result_type.dart';

class FilmReviewsCutbit extends Cubit<FilmReviewsState> {
  final FilmReviewsRepository filmReviewsRepository;

  FilmReviewsCutbit(this.filmReviewsRepository) : super(FilmReviewsState());

  Future<void> getReviews(String filmId) async {
    emit(
      state.copyWith(
        isLoadingGetReviews: true,
        errorMessage: null,
      ),
    );
    final result = await filmReviewsRepository.getReviews(filmId);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoadingGetReviews: false,
            reviews: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoadingGetReviews: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> postReview(
    String filmId,
    int start,
    String content,
  ) async {
    emit(
      state.copyWith(
        isLoadingPostReview: true,
        errorMessage: null,
      ),
    );
    final result =
        await filmReviewsRepository.postReview(filmId, start, content);

    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoadingPostReview: false,
            reviews: [result.data, ...state.reviews ?? []],
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoadingPostReview: false,
            errorMessage: result.message,
          ),
        ),
    });
  }
}
