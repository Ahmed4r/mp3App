import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/login.dart';
import 'package:mp3_app/presentation/Screens/AuthScreen/register.dart';
import 'package:mp3_app/presentation/Screens/beside_Screens/getStarted.dart';

class Mainauth extends StatelessWidget {
  static const String routeName = 'mianAuth';
  const Mainauth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.white,
              size: 17,
            )),
      ),
      backgroundColor: const Color(0xff1C1B1B),
      body: Stack(children: [
        Positioned(
          top: 50.h,
          left: 280.w,
          child: Image.asset(
            'assets/UnionTopRight.png',
            color: Colors.white,
          ),
        ),
        Positioned(
          bottom: 10.h,
          child: Image.asset(
            'assets/mainAuthimage.png',
            scale: 1,
          ),
        ),
        Positioned(
          left: 260,
          bottom: 10.h,
          child: Image.asset(
            'assets/UnionbottomRight.png',
            scale: 1,
            color: Colors.white,
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 100.h,
            ),
            Center(
              child: Image.asset('assets/Vector.png'),
            ),
            SizedBox(
              height: 40.h,
            ),
            Text(
              'Enjoy listening to music',
              style:
                  GoogleFonts.aDLaMDisplay(color: Colors.white, fontSize: 22),
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              'Spotify is a proprietary Swedish audio\n streaming and media services provider',
              style: GoogleFonts.fredoka(color: Colors.white, fontSize: 14),
            ),
            SizedBox(
              height: 50.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Register.routeName);
                    },
                    child: Container(
                      width: 147,
                      height: 73,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xff42C83C)),
                      child: Center(
                        child: Text(
                          'Register',
                          style: GoogleFonts.aDLaMDisplay(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Login.routeName);
                    },
                    child: Container(
                      width: 147,
                      height: 73,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.aDLaMDisplay(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
