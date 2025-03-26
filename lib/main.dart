import 'package:expense_tracker/blocs/expense_bloc.dart';
import 'package:expense_tracker/blocs/expense_event.dart';
import 'package:expense_tracker/screens/main_screen.dart';
import 'package:expense_tracker/services/expense_firestore_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:expense_tracker/theme/app_themes.dart';
import 'package:bloc/bloc.dart';
import 'package:expense_tracker/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  final firestoreService = ExpenseFirestoreService();
  runApp(
    PlatformProvider(
      builder: (context) => BlocProvider(
        create: (context) => ExpenseBloc(firestoreService: firestoreService)
          ..add(LoadExpenses()),
        child: PlatformTheme(
          themeMode: ThemeMode.system,
          materialLightTheme: MaterialAppThemes.lightTheme,
          materialDarkTheme: MaterialAppThemes.darkTheme,
          cupertinoLightTheme: CupertinoAppThemes.lightTheme,
          cupertinoDarkTheme: CupertinoAppThemes.darkTheme,
          builder: (context) => const PlatformApp(
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            home: MainScreen(),
          ),
        ),
      ),
    ),
  );
}
