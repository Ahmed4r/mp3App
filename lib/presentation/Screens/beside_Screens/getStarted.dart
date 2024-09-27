import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mp3_app/main.dart';
import 'package:mp3_app/presentation/Screens/beside_Screens/choosemode.dart';

class Getstarted extends StatelessWidget {
  static const String routeName = 'getStarted';
  const Getstarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            top: 65,
            left: 100.w,
            child: Image.asset('assets/Vector.png'),
          ),
          Positioned(
            top: 650.h,
            left: 60.w,
            child: Text(
              'Enjoy Listening to music',
              style: GoogleFonts.aDLaMDisplay(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
              top: 700,
              left: 50,
              child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, Choosemode.routeName);
                  },
                  child: Container(
                    width: 329,
                    height: 92,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xff42C83C)),
                    child: Center(
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.aDLaMDisplay(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
