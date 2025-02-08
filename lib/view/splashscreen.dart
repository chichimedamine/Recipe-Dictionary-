import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:recipe_dictionary/helpers/colorshelper.dart';
import 'package:recipe_dictionary/view/index.dart';
import 'package:recipe_dictionary/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Future<bool> initPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  @override
  void initState() {
    super.initState();
    initPreferences().then((isLoggedIn) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => isLoggedIn
                ? const Index().animate().fadeIn(duration: const Duration(seconds: 1))
                : const LoginView().animate().fadeIn(duration: const Duration(seconds: 1)),
            transitionDuration: const Duration(seconds: 1),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: ColorHelper.primaryColor,
            /*image: DecorationImage(
              image: AssetImage('assets/images/bg.webp'),
              fit: BoxFit.fill,
            )*/
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/applogo.webp').animate().shake(
                duration: const Duration(seconds: 1),
                hz: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
