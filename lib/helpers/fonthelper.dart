import 'package:flutter/material.dart';

class FontHelper {
  static String getFontFamily() => 'Nexa';

  static TextStyle getLargeText({Color color = Colors.black}) => TextStyle(
        fontSize: 40,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getTitleAppbar({Color color = Colors.black}) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getMediumText({Color color = Colors.black}) => TextStyle(
        fontSize: 24,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getHeading5({Color color = Colors.black}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getHeading6({Color color = Colors.black}) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getSmallText({Color color = Colors.black}) => TextStyle(
        fontSize: 10,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getHeading1({Color color = Colors.black}) => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getHeading2({Color color = Colors.black}) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getHeading3({Color color = Colors.black}) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getHeading4({Color color = Colors.black}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getBodyText({Color color = Colors.black}) => TextStyle(
        fontSize: 16,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getBodyTextBold({Color color = Colors.black}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: getFontFamily(),
        color: color,
      );

  static TextStyle getCaption({Color color = Colors.black}) => TextStyle(
        fontSize: 14,
        fontFamily: getFontFamily(),
        color: color,
      );
}
