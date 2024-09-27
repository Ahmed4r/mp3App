import 'package:flutter/material.dart';
import 'package:mp3_app/presentation/Screens/Homepage/homepage.dart';

class Splashscreen extends StatelessWidget {
  static const String routeName = 'splashScreen';

  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, Homepage.routeName);
      },
    );
    return Image.asset(
      fit: BoxFit.contain,
      'assets/Loading.png',
      scale: 1,
    );
  }
}
