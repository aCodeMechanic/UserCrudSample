import 'package:flutter/material.dart';

// Define Colors based on the design
const Color primaryColor = Color(0xFF1DA1F2);
const Color backgroundColor = Colors.white;
const Color greyBackgroundColor = Color(0xFFF2F2F2);
const Color textFieldBackgroundColor = Color(0xFFEBF2F5);
const Color textFieldBorderColor = Color(0xFFD3D3D3);
const Color textColorPrimary = Colors.black87;
const Color textColorSecondary = Colors.black54;
const Color buttonTextColor = Colors.white;

textTheme(
    {double fontSize = 12.0,
      color = textColorPrimary,
      fontWeight = FontWeight.w400,
      decoration = TextDecoration.none,
      decorationColor = Colors.transparent}) {

  return TextStyle(
    fontFamily: 'Roboto',
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: decorationColor);
}

ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  colorScheme:
      ColorScheme.fromSwatch(primarySwatch: createMaterialColor(primaryColor)),
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    titleTextStyle: TextStyle(fontFamily: 'Roboto',
      color: buttonTextColor,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: IconThemeData(color: buttonTextColor),
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 14.0, color: textColorPrimary),
    bodyMedium: TextStyle(fontFamily: 'Roboto',fontSize: 12.0, color: textColorSecondary),
    titleLarge: TextStyle(fontFamily: 'Roboto',
        fontSize: 22.0, fontWeight: FontWeight.bold, color: textColorPrimary),
    titleMedium: TextStyle(fontFamily: 'Roboto',
        fontSize: 16.0, fontWeight: FontWeight.w500, color: textColorPrimary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: buttonTextColor,
      textStyle: const TextStyle(fontFamily: 'Roboto',fontSize: 12, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      elevation: 0,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      textStyle: const TextStyle(fontFamily: 'Roboto',fontSize: 12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(fontFamily: 'Roboto',color: textColorSecondary),
    hintStyle: TextStyle(fontFamily: 'Roboto',color: textColorSecondary),
    floatingLabelStyle: TextStyle(fontFamily: 'Roboto',color: primaryColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: textFieldBorderColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: textFieldBorderColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: textFieldBorderColor, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    errorStyle: const TextStyle(fontFamily: 'Roboto',color: Colors.redAccent),
    prefixIconColor: textColorSecondary,
    suffixIconColor: textColorSecondary,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
);

// Helper function to create a MaterialColor from a single color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
