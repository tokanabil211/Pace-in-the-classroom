import 'package:flutter/material.dart';
import 'package:gemini_chat_bot/featuers/chat/presentation/views/chat_view.dart';
import 'navigation_bar/navigation_bar_screen.dart';
import 'package:gemini_chat_bot/splash/splash_screen.dart';
void main() {
  runApp(const GeminiApp());
}

class GeminiApp extends StatelessWidget {
  const GeminiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
