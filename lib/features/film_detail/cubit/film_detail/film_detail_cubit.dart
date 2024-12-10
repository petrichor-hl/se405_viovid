import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/film_detail/dtos/film.dart';
import 'package:viovid_app/features/result_type.dart';

part 'film_detail_state.dart';

// Cubit + Repository
class FilmDetailCubit extends Cubit<FilmDetailState> {
  final FilmDetailRepository _filmDetailRepository;

  FilmDetailCubit(this._filmDetailRepository) : super(FilmDetailInProgress());

  void getFilmDetail(String filmId) async {
    final result = await _filmDetailRepository.getFilmDetail(filmId);
    return (switch (result) {
      Success() => emit(FilmDetailSuccess(result.data)),
      Failure() => emit(FilmDetailFailure(result.message)),
    });
  }
}
