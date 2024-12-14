import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class BrightnessBar extends StatefulWidget {
  const BrightnessBar({
    super.key,
    required this.startCountdownToDismissControls,
    required this.cancelTimer,
  });

  final void Function() startCountdownToDismissControls;
  final void Function() cancelTimer;

  @override
  State<BrightnessBar> createState() => _BrightnessBarState();
}

class _BrightnessBarState extends State<BrightnessBar> {
  double brightness = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 130,
          child: RotatedBox(
            quarterTurns: -1,
            child: Slider(
              value: brightness,
              onChangeStart: (_) => widget.cancelTimer(),
              onChanged: (value) {
                try {
                  ScreenBrightness().setApplicationScreenBrightness(brightness);
                } catch (e) {
                  //
                }
                setState(() {
                  brightness = value;
                });
              },
              onChangeEnd: (_) => widget.startCountdownToDismissControls,
            ),
          ),
        ),
        const Icon(
          Icons.sunny,
          color: Colors.white,
        ),
      ],
    );
  }
}
