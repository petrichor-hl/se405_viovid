import 'package:flutter/material.dart';

final _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5];

class VideoSpeedDialog extends StatelessWidget {
  const VideoSpeedDialog({
    super.key,
    required this.currentSpeedOption,
    required this.onChanged,
  });

  final double currentSpeedOption;
  final void Function(double? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ..._speedOptions.map(
                (speedOption) => RadioListTile(
                  title: Text('${speedOption}x'),
                  value: speedOption,
                  groupValue: currentSpeedOption,
                  onChanged: onChanged,
                  dense: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
