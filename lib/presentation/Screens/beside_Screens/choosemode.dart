import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mp3_app/main.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/mainauth.dart';

class Choosemode extends StatelessWidget {
  static const String routeName = 'choosemode';
  const Choosemode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/chooseMode.png',
              scale: 1,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 65.h,
            left: 100.w,
            child: Image.asset('assets/Vector.png'),
          ),
          Positioned(
            top: 400.h,
            left: 125.w,
            child: const Text('Choose Mode',
                style: TextStyle(
                    fontFamily: 'Satoshi', color: Colors.white, fontSize: 22)),
          ),
          Positioned(
              left: 100.w,
              top: 500.h,
              child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                          width: 73.w,
                          height: 73.h,
                          decoration: const BoxDecoration(),
                          child: Stack(alignment: Alignment.center, children: [
                            Image.asset('assets/Ellipse 14.png'),
                            const Icon(
                              Icons.dark_mode_outlined,
                              color: Colors.white,
                              size: 32,
                            )
                          ])),
                      SizedBox(width: 70.w),
                      Container(
                          width: 73.w,
                          height: 73.h,
                          decoration: const BoxDecoration(),
                          child: Stack(alignment: Alignment.center, children: [
                            Image.asset('assets/Ellipse 13.png'),
                            const Icon(
                              Icons.light_mode_outlined,
                              color: Colors.white,
                              size: 32,
                            )
                          ])),
                    ],
                  ))),
          Positioned(
              top: 700.h,
              left: 50.w,
              child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Mainauth.routeName);
                  },
                  child: Container(
                    width: 329.w,
                    height: 92.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xff42C83C)),
                    child: const Center(
                      child: Text('Continue',
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
