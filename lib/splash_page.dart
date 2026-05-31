import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const Color sakuraPink = Color(0xfff48fb1);
  static const Color sakuraLight = Color(0xffffd6e7);
  static const Color sakuraDark = Color(0xffad5274);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3200,
      splashIconSize: 320,
      backgroundColor: sakuraPink,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.fade,
      nextScreen: const HomePage(),
      splash: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              sakuraPink,
              sakuraLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 58,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.local_florist,
                size: 66,
                color: sakuraPink,
              ),
            ),
            SizedBox(height: 22),
            Text(
              'SakuStaff',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Blooming Employee Data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                letterSpacing: 0.8,
              ),
            ),
            SizedBox(height: 18),
            Text(
              'CRUD • Photo • GPS',
              style: TextStyle(
                color: sakuraDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}