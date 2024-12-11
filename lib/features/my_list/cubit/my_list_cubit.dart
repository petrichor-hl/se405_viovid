import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/my_list/data/my_list_repository.dart';
import 'package:viovid_app/features/result_type.dart';
import 'package:viovid_app/features/topic/dtos/simple_film.dart';

part 'my_list_state.dart';

// Cubit + Repository
class MyListCubit extends Cubit<MyListState> {
  final MyListRepository _myListRepository;

  MyListCubit(this._myListRepository) : super(MyListInitial());

  Future<void> getMyList() async {
    final result = await _myListRepository.getMyList();
    return (switch (result) {
      Success() => emit(MyListSuccess(result.data)),
      Failure() => emit(MyListFailure(result.message)),
    });
  }

  Future<void> addFilmToMyList(String filmId) async {
    final currentList = (state as MyListSuccess).films;
    emit(MyListInProgress());
    final result = await _myListRepository.addFilmToMyList(filmId);
    switch (result) {
      case Success():
        final updatedList = [...currentList, result.data];
        emit(MyListSuccess(updatedList));
        break;
      case Failure():
        emit(MyListFailure(result.message));
        break;
    }
  }

  Future<void> removeFilmFromMyList(String filmId) async {
    final currentList = (state as MyListSuccess).films;
    emit(MyListInProgress());
    final result = await _myListRepository.removeFilmFromMyList(filmId);
    switch (result) {
      case Success():
        final updatedList =
            currentList.where((film) => film.filmId != filmId).toList();
        emit(MyListSuccess(updatedList));
        break;
      case Failure():
        emit(MyListFailure(result.message));
        break;
    }
  }
}
