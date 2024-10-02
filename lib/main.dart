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

class Mp3App extends StatelessWidget {
  final String route;
  const Mp3App({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Splashscreen(),
          initialRoute: route,
          routes: {
            Splashscreen.routeName: (context) => Splashscreen(),
            Homepage.routeName: (context) => const Bottomnavbar(),
            Showsurah.routeName: (context) => const Showsurah(),
            Getstarted.routeName: (context) => const Getstarted(),
            Choosemode.routeName: (context) => const Choosemode(),
            Mainauth.routeName: (context) => const Mainauth(),
            Login.routeName: (context) => const Login(),
            Register.routeName: (context) => const Register(),
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

  // Save the token in shared preferences for testing (if needed)
  // await Sharedprefutils.saveData(key: 'userToken', value: 'OSU593IJ2WdsboIcgy1mkkOOFpJ2');

  // Retrieve the token from shared preferences
  String? token = Sharedprefutils.getData(key: 'usertoken') as String?;
  print(
      'Tokennnnnnnnnnnnnnnnnnnnnnn: $token'); // Check if token is being retrieved properly

  // Set the initial route based on the presence of the token
  String initialRoute;
  if (token == null) {
    initialRoute = Splashscreen.routeName;
  } else {
    initialRoute = Homepage.routeName;
  }

  runApp(Mp3App(route: initialRoute));
}
