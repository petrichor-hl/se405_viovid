import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:viovid_app/features/film_detail/cubit/film_detail_cubit.dart';
import 'package:viovid_app/screens/film_detail/components/cast_tab.dart';
import 'package:viovid_app/screens/film_detail/components/season_tab.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomInfoState();
}

class _BottomInfoState extends State<BottomTabs> {
  late final _filmDetailState = context.read<FilmDetailCubit>().state;
  late final _film = (switch (_filmDetailState) {
    FilmDetailSuccess() => _filmDetailState.film,
    _ => null,
  })!;
  late final _isMovie = _film.seasons[0].name == '';
  late int _segmentIndex = _isMovie ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: CupertinoSlidingSegmentedControl(
            backgroundColor: Colors.white.withAlpha(50),
            thumbColor: Colors.black,
            groupValue: _segmentIndex,
            children: _isMovie
                ? {
                    1: _buildSegment('Diễn viên'),
                    2: _buildSegment('Đội ngũ'),
                  }
                : {
                    0: _buildSegment('Tập phim'),
                    1: _buildSegment('Diễn viên'),
                    2: _buildSegment('Đội ngũ'),
                  },
            onValueChanged: (index) {
              setState(() {
                _segmentIndex = index!;
              });
            },
          ),
        ),
        const Gap(14),
        if (_segmentIndex == 0) const SeasonTab(),
        if (_segmentIndex == 1) const CastTab(),
        if (_segmentIndex == 2) const SizedBox(),
      ],
    );
  }

  Widget _buildSegment(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
