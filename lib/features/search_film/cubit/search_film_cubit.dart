import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/search_film/cubit/search_film_state.dart';
import 'package:viovid_app/features/search_film/data/search_film_repository.dart';

class SearchFilmCubit extends Cubit<SearchFilmState> {
  final SearchFilmRepository _searchFilmRepository;

  SearchFilmCubit(this._searchFilmRepository) : super(SearchFilmState());

  Future<void> searchFilm(
    String searchText,
    // LoadingState loadingState,
  ) async {
    // int pageIndexToFetch;

    // switch (loadingState) {
    //   case LoadingState.getFirst:
    //     pageIndexToFetch = 0;
    //     emit(state.copyWith(
    //       loadingState: LoadingState.getFirst,
    //       message: "",
    //     ));
    //     break;

    //   case LoadingState.loadingMore:
    //     pageIndexToFetch = state.pageIndex + 1;
    //     emit(state.copyWith(
    //       loadingState: LoadingState.loadingMore,
    //       message: "",
    //     ));
    //     break;

    //   case LoadingState.none:
    //     return;
    // }

    emit(
      state.copyWith(isLoading: true),
    );

    final result = await _searchFilmRepository.searchFilm(searchText);

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            // loadingState: LoadingState.none,
            isLoading: false,
            // pageIndex: result.data.pageIndex,
            films: result.data.items,
          ),
        );
        break;

      case Failure():
        emit(
          state.copyWith(
            isLoading: false,
            message: result.message,
          ),
        );
        break;
    }
  }
}
