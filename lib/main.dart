import 'package:flutter/material.dart';
import 'splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color sakuraPink = Color(0xfff48fb1);
  static const Color sakuraDark = Color(0xffad5274);
  static const Color sakuraBg = Color(0xfffff7fa);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SakuStaff',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: sakuraBg,
        primaryColor: sakuraPink,
        colorScheme: ColorScheme.fromSeed(
          seedColor: sakuraPink,
          primary: sakuraPink,
          secondary: const Color(0xffffc1d6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: sakuraPink,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: sakuraPink,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: sakuraPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}