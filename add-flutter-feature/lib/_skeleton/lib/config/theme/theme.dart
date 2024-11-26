import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:{{ appPackageName }}/config/theme/brand_colors.dart';

class AppTheme {
  AppTheme._();

  static final text = TextTheme(
    displaySmall: TextStyle(fontSize: 12),
    displayMedium: TextStyle(fontSize: 24),
    displayLarge: TextStyle(fontSize: 36),
  );

  static const darkColorScheme = ColorScheme.dark(
    primary: Colors.white,
    onPrimary: AppColor.teal700,
    secondary: AppColor.green700,
    onSecondary: AppColor.yellow300,
    surface: AppColor.teal500,
    onSurface: AppColor.white900,
    error: AppColor.red700,
    onError: AppColor.red300,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    colorScheme: darkColorScheme,
    canvasColor: darkColorScheme.surface,
    scaffoldBackgroundColor: darkColorScheme.surface,
    fontFamily: GoogleFonts.inconsolata(fontWeight: FontWeight.w600).fontFamily,
    textTheme: AppTheme.text,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.red700,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Color.fromRGBO(255, 142, 49, 0.847),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(),
  );
}
