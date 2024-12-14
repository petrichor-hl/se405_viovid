import 'package:flutter/material.dart';

class VideoProgressBar extends StatelessWidget {
  const VideoProgressBar({
    super.key,
    required this.label,
    required this.progress,
    required this.remainingTime,
    required this.onChangeStart,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final String label;
  final double progress;
  final String remainingTime;

  final void Function() onChangeStart;
  final void Function(double value) onChanged;
  final void Function(double value) onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: progress,
            label: label,
            onChangeStart: (_) => onChangeStart(),
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ),
        Text(
          remainingTime,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
