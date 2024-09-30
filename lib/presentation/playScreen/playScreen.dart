import 'package:flutter/material.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/presentation/Screens/Homepage/homepage.dart';

class Playscreen extends StatelessWidget {
  static const String routeName = 'playScreen';
  const Playscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Appcolors.primaryColor,
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Now playing',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Homepage.routeName);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Appcolors.whiteColor,
              
            )),
      ),
    );
  }
}
