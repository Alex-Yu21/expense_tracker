import 'package:expense_tracker/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:expense_tracker/theme/app_themes.dart';

void main() {
  runApp(
    PlatformProvider(
      builder: (context) => PlatformTheme(
        themeMode: ThemeMode.system,
        materialLightTheme: MaterialAppThemes.lightTheme,
        materialDarkTheme: MaterialAppThemes.darkTheme,
        cupertinoLightTheme: CupertinoAppThemes.lightTheme,
        cupertinoDarkTheme: CupertinoAppThemes.darkTheme,
        builder: (context) => PlatformApp(
          localizationsDelegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
          ],
          home: MainScreen(),
        ),
      ),
    ),
  );
}
