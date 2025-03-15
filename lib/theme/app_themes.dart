import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 180),
);

final kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

CardTheme buildCardTheme(Color cardColor) {
  return CardTheme(
    color: cardColor,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );
}

class PlatformTextThemes {
  static final TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}

class MaterialAppThemes {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: kColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: kColorScheme.onPrimaryContainer,
      foregroundColor: kColorScheme.primaryContainer,
    ),
    cardTheme: buildCardTheme(kColorScheme.secondaryContainer),
    textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: PlatformTextThemes.titleStyle.copyWith(
            color: kColorScheme.onSecondaryContainer,
          ),
        ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: kDarkColorScheme,
    cardTheme: buildCardTheme(kDarkColorScheme.secondaryContainer),
    textTheme: ThemeData.dark().textTheme.copyWith(
          titleLarge: PlatformTextThemes.titleStyle.copyWith(
            color: kDarkColorScheme.onSecondaryContainer,
          ),
        ),
  );
}

class CupertinoAppThemes {
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: kColorScheme.primary,
    barBackgroundColor: kColorScheme.onPrimaryContainer,
    textTheme: CupertinoTextThemeData(
      textStyle: PlatformTextThemes.titleStyle.copyWith(
        color: kColorScheme.onSecondaryContainer,
      ),
    ),
  );

  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: kDarkColorScheme.primary,
    barBackgroundColor: kDarkColorScheme.onPrimaryContainer,
    textTheme: CupertinoTextThemeData(
      textStyle: PlatformTextThemes.titleStyle.copyWith(
        color: kDarkColorScheme.onSecondaryContainer,
      ),
    ),
  );
}
