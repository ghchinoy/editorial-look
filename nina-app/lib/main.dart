import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nina/login_screen.dart';
import 'package:nina/theme.dart';
import 'firebase_options.dart'; // Make sure to create this file

/// The main entry point for the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // You need to generate your own firebase_options.dart file
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatefulWidget {
  /// Creates a new [MyApp] instance.
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

/// The state for the [MyApp] widget.
class MyAppState extends State<MyApp> {
  /// The notifier for the current theme mode.
  final ValueNotifier<ThemeMode> _themeModeNotifier =
      ValueNotifier(ThemeMode.dark);

  /// Toggles the theme of the application.
  void toggleTheme() {
    _themeModeNotifier.value =
        _themeModeNotifier.value == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Editorial Look',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: LoginScreen(toggleTheme: toggleTheme),
        );
      },
    );
  }
}
