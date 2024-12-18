import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/my_list/cubit/my_list_cubit.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.filmId,
    required this.isAlreadyInMyList,
  });

  final String filmId;
  final bool isAlreadyInMyList;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        isAlreadyInMyList
            ? context.read<MyListCubit>().removeFilmFromMyList(filmId)
            : context.read<MyListCubit>().addFilmToMyList(filmId);
      },
      icon: Icon(
        isAlreadyInMyList ? Icons.check_rounded : Icons.add_rounded,
        key: ValueKey(isAlreadyInMyList),
        color: isAlreadyInMyList ? Colors.amber : Colors.white,
      ),
    );
  }
}
