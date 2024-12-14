import 'package:flutter/material.dart';

const primaryColor = Color.fromARGB(255, 229, 9, 21);

final appColorScheme = ColorScheme.fromSwatch().copyWith(
  primary: primaryColor,
);

const appBarTheme = AppBarTheme(
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  centerTitle: true,
);

final appFilledButtonTheme = FilledButtonThemeData(
  style: ButtonStyle(
    backgroundColor: const WidgetStatePropertyAll(
      primaryColor, // Màu nền
    ),
    foregroundColor: const WidgetStatePropertyAll(
      Colors.white,
    ), // Màu chữ
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ), // Padding
    ),
    textStyle: const WidgetStatePropertyAll(
      TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  ),
);
