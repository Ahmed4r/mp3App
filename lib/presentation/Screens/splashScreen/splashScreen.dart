import 'package:flutter/material.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/register.dart';

class Splashscreen extends StatelessWidget {
  static const String routeName = 'splashScreen';

  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, Register.routeName);
      },
    );
    return Image.asset(
      fit: BoxFit.contain,
      'assets/noon.png',
      scale: 1,
    );
  }
}
