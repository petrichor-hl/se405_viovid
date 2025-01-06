import 'package:viovid_app/features/topic/dtos/simple_film.dart';

sealed class RecommendationsState {}

class RecommendationsInitial extends RecommendationsState {}

class RecommendationsInProgress extends RecommendationsState {}

class RecommendationsSuccess extends RecommendationsState {
  final List<SimpleFilm> films;

  RecommendationsSuccess(this.films);
}

class RecommendationsFailure extends RecommendationsState {
  final String message;

  RecommendationsFailure(this.message);
}
