import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/personal_detail_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/read_text_screen.dart';
import 'screens/text_audio_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/success_screen.dart';

void main() {
  runApp(const DyslexiaApp());
}

class DyslexiaApp extends StatelessWidget {
  const DyslexiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dyslexia App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',  // Start from Splash Screen
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/personal_detail': (context) => const PersonalDetailScreen(),
        '/menu': (context) => const MenuScreen(),
        '/read_text': (context) => const ReadTextScreen(),
        '/text_audio': (context) => const TextAudioScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/success': (context) => const SuccessScreen(),
      },
    );
  }
}
