import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/data/sharedpref/sharedprefUtils.dart';
import 'package:noon/firebase_options.dart';
import 'package:noon/presentation/Screens/AuthScreen/login.dart';
import 'package:noon/presentation/Screens/AuthScreen/mainauth.dart';
import 'package:noon/presentation/Screens/AuthScreen/register.dart';
import 'package:noon/presentation/Screens/Discovry/DiscoveryScreen.dart';
import 'package:noon/presentation/Screens/Homepage/homepage.dart';

import 'package:noon/presentation/Screens/Homepage/showSur/showsurah.dart';
import 'package:noon/presentation/Screens/beside_Screens/choosemode.dart';
import 'package:noon/presentation/Screens/beside_Screens/getStarted.dart';
import 'package:noon/presentation/Screens/favorites/favorites.dart';
import 'package:noon/presentation/Screens/splashScreen/splashScreen.dart';

import 'package:noon/presentation/widgets/bottomNavBar.dart';
import 'package:noon/presentation/widgets/nowplaying.dart';

class mp3App extends StatelessWidget {
  String route;
  mp3App({required this.route});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Splashscreen(),
          // put splash in intial
          initialRoute: route,
          routes: {
            Homepage.routeName: (context) => const Bottomnavbar(),
            Showsurah.routeName: (context) => const Showsurah(),
            Getstarted.routeName: (context) => const Getstarted(),
            Choosemode.routeName: (context) => const Choosemode(),
            Mainauth.routeName: (context) => const Mainauth(),
            Login.routeName: (context) => const Login(),
            Register.routeName: (context) => const Register(),
            // Search.routeName: (context) => const Search(),
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
  await Sharedprefutils.init();
  String? token = Sharedprefutils.getData(key: 'userToken') as String?;

  String initialRoute;
  if (token == null) {
    initialRoute = Splashscreen.routeName;
  } else {
    initialRoute = Homepage.routeName;
  }

  runApp(mp3App(route: initialRoute));
}
//ahmedrady03@gmail.com
//ahmed12345
//token = OSU593IJ2WdsboIcgy1mkkOOFpJ2