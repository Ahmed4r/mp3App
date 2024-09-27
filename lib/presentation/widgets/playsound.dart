import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/presentation/widgets/nowplaying.dart';

class CustomPlaysound extends StatelessWidget {
  String surah;
  String reciter;
  String audio;
  CustomPlaysound(
      {required this.surah, required this.reciter, required this.audio});
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () async {
                // Create a player
                Navigator.pushNamed(context, Nowplaying.routeName, arguments: {
                  'audio': audio,
                  'surah': surah,
                  'reciter': reciter
                });
              },
              child: Container(
                  width: 55.sp,
                  height: 55.sp,
                  decoration: BoxDecoration(
                      color: Appcolors.favContiner,
                      borderRadius: BorderRadius.circular(50)),
                  child: Image.asset('assets/Play.png'))),
          SizedBox(
            width: 40.w,
          ),
          Container(
            width: 200.w,
            height: 200.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: Fontstyle.fontname,
                      color: Colors.white),
                ),
                Text(
                  reciter,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: Fontstyle.fontname,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/Heart.png',
                scale: 1,
              ))
        ],
      ),
    );
  }
}
