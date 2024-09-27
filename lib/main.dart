import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/login.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/mainauth.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/register.dart';
import 'package:mp3_app/presentation/Screens/Homepage/homepage.dart';
import 'package:mp3_app/presentation/Screens/beside_Screens/choosemode.dart';
import 'package:mp3_app/presentation/Screens/beside_Screens/getStarted.dart';
import 'package:mp3_app/presentation/Screens/splashScreen/splashScreen.dart';

class mp3App extends StatelessWidget {
  const mp3App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Splashscreen(),
          initialRoute: Getstarted.routeName,
          routes: {
            Homepage.routeName: (context) => const Homepage(),
            Getstarted.routeName: (context) => const Getstarted(),
            Choosemode.routeName: (context) => const Choosemode(),
            Mainauth.routeName: (context) => const Mainauth(),
            Login.routeName: (context) => const Login(),
            Register.routeName: (context) => const Register(),
          },
        );
      },
    );
  }
}

void main() {
  runApp(const mp3App());
}
