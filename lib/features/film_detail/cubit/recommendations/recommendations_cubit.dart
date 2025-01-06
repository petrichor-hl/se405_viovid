import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/film_detail/cubit/recommendations/recommendations_state.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/result_type.dart';

class RecommendationsCubit extends Cubit<RecommendationsState> {
  final FilmDetailRepository _filmDetailRepository;

  RecommendationsCubit(this._filmDetailRepository)
      : super(RecommendationsInitial());

  void getRecommendations(String type, String filmId) async {
    emit(RecommendationsInProgress());
    final result = await _filmDetailRepository.getRecommendations(type, filmId);
    return (switch (result) {
      Success() => emit(RecommendationsSuccess(result.data)),
      Failure() => emit(RecommendationsFailure(result.message)),
    });
  }
}
