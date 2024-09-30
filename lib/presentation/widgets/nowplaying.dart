import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/data/model/reciterResponse.dart';
import 'package:mp3_app/presentation/Screens/Homepage/cubit/homepageCubit.dart';
import 'package:mp3_app/presentation/Screens/Homepage/cubit/homepageStates.dart';
import 'package:mp3_app/presentation/Screens/Homepage/homepage.dart';
import 'package:mp3_app/presentation/widgets/progressBar.dart';

class Nowplaying extends StatefulWidget {
  static const String routeName = 'nowPlaying';
  const Nowplaying({super.key});

  @override
  State<Nowplaying> createState() => _NowplayingState();
}

class _NowplayingState extends State<Nowplaying> {
  final player = AudioPlayer();
  Homepagecubit cubit = Homepagecubit();

  @override
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    String url = args?['url'] ?? 0;
    String reciter = args?['reciter'] ?? 'no reciter found';
    String surahName = args?['surah'] ?? 'no reciter found';
    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: Column(
        children: [
          SizedBox(height: 40.h),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, Homepage.routeName);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20.sp,
                  color: Appcolors.whiteColor,
                ),
              ),
              SizedBox(width: 100.w),
              const Text(
                'Now playing',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'Satoshi',
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.network(
              'https://m.media-amazon.com/images/I/71tO3oeRtML._UF894,1000_QL80_.jpg',
              width: 300.0,
              height: 300.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 40.h),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reciter,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                      ),
                    ),
                    Text(
                      surahName,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 185.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite,
                      size: 36.sp,
                    )),
              ],
            ),
          ),
          SizedBox(height: 70.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  player.setLoopMode(LoopMode.one);
                },
                icon: Image.asset('assets/Repeate 3.png'),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/Previous.png'),
              ),
              Container(
                height: 70.h,
                width: 70.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: Appcolors.ButtonColor,
                ),
                child: IconButton(
                  onPressed: () {
                    player.setUrl(url);
                    player.play();
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  player.seekToNext();
                },
                icon: Image.asset('assets/Next.png'),
              ),
              IconButton(
                onPressed: () {
                  player.shuffle();
                },
                icon: Image.asset('assets/Shuffle 2.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
