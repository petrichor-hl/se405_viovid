import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/film_detail/cubit/casts/casts_state.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/result_type.dart';

// Cubit + Repository
class CastsCubit extends Cubit<CastsState> {
  final FilmDetailRepository _filmDetailRepository;

  CastsCubit(this._filmDetailRepository) : super(CastsInitial());

  void getCasts(String filmId) async {
    emit(CastsInProgress());
    final result = await _filmDetailRepository.getCasts(filmId);
    return (switch (result) {
      Success() => emit(CastsSuccess(result.data)),
      Failure() => emit(CastsFailure(result.message)),
    });
  }
}
