import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/film_detail/cubit/crews/crews_state.dart';
import 'package:viovid_app/features/film_detail/data/film_detail_repository.dart';
import 'package:viovid_app/features/result_type.dart';

// Cubit + Repository
class CrewsCubit extends Cubit<CrewsState> {
  final FilmDetailRepository _filmDetailRepository;

  CrewsCubit(this._filmDetailRepository) : super(CrewsInitial());

  void getCrews(String filmId) async {
    emit(CrewsInProgress());
    final result = await _filmDetailRepository.getCrews(filmId);
    return (switch (result) {
      Success() => emit(CrewsSuccess(result.data)),
      Failure() => emit(CrewsFailure(result.message)),
    });
  }
}
