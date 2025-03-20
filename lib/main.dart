import 'package:expense_tracker/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:bloc/bloc.dart';
import 'package:expense_tracker/simple_bloc_observer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
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
