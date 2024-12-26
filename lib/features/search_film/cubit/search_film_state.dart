import 'package:viovid_app/features/topic/dtos/simple_film.dart';

class SearchFilmState {
  // final String searchText;
  // final int pageIndex;
  // final int pageSize;
  final List<SimpleFilm>? films;
  final bool isLoading;
  // final LoadingState loadingState;
  final String message;

  SearchFilmState({
    // this.searchText = "",
    // this.pageIndex = 0,
    // this.pageSize = 15,
    this.films,
    this.isLoading = false,
    // this.loadingState = LoadingState.getFirst,
    this.message = "",
  });

  SearchFilmState copyWith({
    // int? pageIndex,
    // int? pageSize,
    List<SimpleFilm>? films,
    bool? isLoading,
    // LoadingState? loadingState,
    String? message,
  }) {
    return SearchFilmState(
      // pageIndex: pageIndex ?? this.pageIndex,
      // pageSize: pageSize ?? this.pageSize,
      films: films ?? this.films,
      isLoading: isLoading ?? this.isLoading,
      // loadingState: loadingState ?? this.loadingState,
      message: message ?? this.message,
    );
  }
}

enum LoadingState {
  none,
  getFirst,
  loadingMore,
}
