import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'package:flutter_localizations/flutter_localizations.dart';

// Screens
// Removed: import 'package:newone/screens/LogIn/Phone_Number_Screen.dart';
// Removed: import 'package:newone/screens/LogIn/Otp_Verification_Screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/user_name_screen.dart';
import 'screens/home_screen.dart';

// Localization
import 'generated/l10n.dart';
import 'lan/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable SQLite FFI for desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Preference flags
  bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  String? userName = prefs.getString('user_name');

  // Debug logs
  print('=== App Launch Info ===');
  print('Onboarding Complete: $onboardingComplete');
  print('User Name: $userName');

  // Decide initial screen
  Widget startScreen;
  if (!onboardingComplete) {
    startScreen = OnboardingScreen();
  } else if (userName == null || userName.isEmpty) {
    startScreen = UserNameScreen();
  } else {
    startScreen = HomeScreen();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: MyApp(startScreen: startScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen;
  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer Diary',
      theme: ThemeData(primarySwatch: Colors.teal),
      locale: Provider.of<LocaleProvider>(context).locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      home: startScreen,
    );
  }
}
