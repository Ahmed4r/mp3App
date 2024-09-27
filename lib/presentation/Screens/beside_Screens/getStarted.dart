import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/main.dart';
import 'package:mp3_app/presentation/Screens/beside_Screens/choosemode.dart';

class Getstarted extends StatelessWidget {
  static const String routeName = 'getStarted';
  const Getstarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/getStartedBackGround.png',
              scale: 1,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 65.h,
            left: 100.w,
            child: Image.asset(
              'assets/noon.png',
              scale: 1.3,
            ),
          ),
          Positioned(
            top: 650.h,
            left: 60.w,
            child: Text('Enjoy Listening to music',
                style: TextStyle(
                    fontFamily: 'Satoshi', color: Colors.white, fontSize: 25)),
          ),
          Positioned(
              top: 700.h,
              left: 50.w,
              child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, Choosemode.routeName);
                  },
                  child: Container(
                    width: 329.w,
                    height: 92.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xff42C83C)),
                    child: Center(
                      child: Text('Get Started',
                          style: TextStyle(
                              fontFamily: 'Satoshi',
                              color: Colors.white,
                              fontSize: 22)),
                    ),
                  )))
        ],
      ),
    );
  }
}
