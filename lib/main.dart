import 'package:audio_service/audio_service.dart';
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
import 'package:noon/presentation/Screens/Homepage/aduioHandler.dart';
import 'package:noon/presentation/Screens/Homepage/homepage.dart';
import 'package:noon/presentation/Screens/Homepage/showSur/showsurah.dart';
import 'package:noon/presentation/Screens/favorites/favorites.dart';
import 'package:noon/presentation/Screens/splashScreen/splashScreen.dart';
import 'package:noon/presentation/donwload.dart';
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
            Splashscreen.routeName: (context) => const Splashscreen(),
            Homepage.routeName: (context) => const Bottomnavbar(),
            Showsurah.routeName: (context) => const Showsurah(),
            Mainauth.routeName: (context) => const Mainauth(),
            Login.routeName: (context) => const Login(),
            Register.routeName: (context) => const Register(),
            NowPlaying.routeName: (context) => const NowPlaying(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            Favoritescreen.routeName: (context) => const Favoritescreen(),
            DownloadScreen.routeName: (context) =>  DownloadScreen(),
          },
        );
      },
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseFirestore.instance.enableNetwork();
  await Sharedprefutils.init();

  String? token = Sharedprefutils.getData(key: 'usertoken') as String?;
  print('Tokennnnnnnnnnnnnnnnnnnnnnn: $token');

  String initialRoute;
  if (token == null) {
    initialRoute = Splashscreen.routeName;
  } else {
    initialRoute = Homepage.routeName;
  }

  AudioService.init(
      builder: () => MyAudioHandler(),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.example.audio_service.channel',
        androidNotificationChannelName: 'Audio Service',
        androidNotificationOngoing: true,
      ));

  runApp(
    Mp3App(
      route: initialRoute,
    ),
  );
}
