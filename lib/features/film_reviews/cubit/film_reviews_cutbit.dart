import 'package:dart_openai/dart_openai.dart';
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
        errorMessage: "",
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
        errorMessage: "",
      ),
    );

    OpenAIModerationModel moderation = await OpenAI.instance.moderation.create(
      /*
        https://platform.openai.com/docs/models#moderation
        model: "text-moderation-007",
        Nếu chỉ có văn được được gửi thì server sẽ sử dụng text-moderation-007
        Vừa có hình ảnh vừa có văn bản thì server sẽ sử dụng omni-moderation-2024-09-26
      */
      input: content,
    );

    final flagged = moderation.results[0].flagged;
    if (flagged) {
      emit(
        state.copyWith(
          isLoadingPostReview: false,
          errorMessage: "Bình luận của bạn chứa nội dung tiêu cực.",
        ),
      );

      return;
    }

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
