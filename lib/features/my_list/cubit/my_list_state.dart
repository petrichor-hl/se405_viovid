part of 'my_list_cubit.dart';

// Cách 1:
sealed class MyListState {}

class MyListInitial extends MyListState {}

class MyListInProgress extends MyListState {}

class MyListSuccess extends MyListState {
  final List<SimpleFilm> films;

  MyListSuccess(this.films);
}

class MyListFailure extends MyListState {
  final String message;

  MyListFailure(this.message);
}

// Cách 2:
// enum MyListStatus { initial, loading, success, error }

// class MyListState {
//   final MyListStatus status;
//   final List<SimpleFilm> movies;
//   final String? errorMessage;

//   MyListState({
//     required this.status,
//     this.movies = const [],
//     this.errorMessage,
//   });

//   MyListState copyWith({
//     MyListStatus? status,
//     List<SimpleFilm>? movies,
//     String? errorMessage,
//   }) {
//     return MyListState(
//       status: status ?? this.status,
//       movies: movies ?? this.movies,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
// }
