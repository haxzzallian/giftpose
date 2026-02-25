import 'package:flutter/material.dart';
import 'package:giftpose_app/theme/colors.dart';

class AppTheme {
  static _border([Color color = AppColor.borderSeparator2Color]) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      );

  static final lightThemeMode = ThemeData.light().copyWith(
    dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle:
            MenuStyle(backgroundColor: MaterialStatePropertyAll(Colors.red))),
    //radioTheme: RadioThemeData(fillColor: MaterialStateProperty.),
    primaryColor: appPrimaryColor,
    appBarTheme: const AppBarTheme(backgroundColor: appBackgroundColor),
    scaffoldBackgroundColor: appBackgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      //focusedBorder: _border(AppPallete.gradient2),
    ),
  );
}
