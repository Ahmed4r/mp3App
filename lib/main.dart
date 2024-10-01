import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp3_app/firebase_options.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/login.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/mainauth.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/register.dart';
import 'package:mp3_app/presentation/Screens/Discovry/DiscoveryScreen.dart';
import 'package:mp3_app/presentation/Screens/Homepage/homepage.dart';
import 'package:mp3_app/presentation/Screens/Homepage/search.dart';
import 'package:mp3_app/presentation/Screens/Homepage/showSur/showsurah.dart';
import 'package:mp3_app/presentation/Screens/beside_Screens/choosemode.dart';
import 'package:mp3_app/presentation/Screens/beside_Screens/getStarted.dart';
import 'package:mp3_app/presentation/Screens/favorites/favorites.dart';
import 'package:mp3_app/presentation/Screens/splashScreen/splashScreen.dart';

import 'package:mp3_app/presentation/widgets/bottomNavBar.dart';
import 'package:mp3_app/presentation/widgets/nowplaying.dart';

class mp3App extends StatelessWidget {
  const mp3App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Splashscreen(),
          // put splash in intial
          initialRoute: Homepage.routeName,
          routes: {
            Homepage.routeName: (context) => const Bottomnavbar(),
            Showsurah.routeName: (context) => const Showsurah(),
            Getstarted.routeName: (context) => const Getstarted(),
            Choosemode.routeName: (context) => const Choosemode(),
            Mainauth.routeName: (context) => const Mainauth(),
            Login.routeName: (context) => const Login(),
            Register.routeName: (context) => const Register(),
            Search.routeName: (context) => const Search(),
            Nowplaying.routeName: (context) => const Nowplaying(),
            DonwloadScreen.routeName: (context) => DonwloadScreen(),
            Favoritescreen.routeName: (context) => Favoritescreen(),
          },
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseFirestore.instance.enableNetwork();

  runApp(const mp3App());
}
