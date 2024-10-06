import 'package:flutter/material.dart';
import 'package:noon/presentation/Screens/AuthScreen/login.dart';

class Splashscreen extends StatefulWidget {
  static const String routeName = 'splashScreen';

  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, Login.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      fit: BoxFit.contain,
      'assets/splash.png',
      scale: 1,
    );
  }
}
