import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_app/appTheme.dart';
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
  bool isPlaying = false;
  late String audio;
  late String surah;

  double progress = 0.0;
  late StreamSubscription<Duration> positionSubscription;
  late StreamSubscription<PlayerState> playerStateSubscription;

  @override
  void initState() {
    super.initState();
    positionSubscription = player.positionStream.listen((position) {
      setState(() {
        progress = position.inSeconds.toDouble();
      });
    });

    playerStateSubscription = player.playerStateStream.listen((state) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      audio = arguments['audio'];
      surah = arguments['surah'];
     
      play(audio);
    } else {
      // Handle the error case
      print("No arguments were passed to Nowplaying screen");
    }

    player.playerStateStream.listen((state) {
      if (state.playing == false) {
        setState(() {
          isPlaying = false;
        });
      }
    });

    player.positionStream.listen((position) {
      setState(() {
        progress = position.inSeconds
            .toDouble(); // Update progress regardless of playing state
      });
    });
  }

  @override
  void dispose() {
    positionSubscription.cancel(); // Cancel the position subscription
    playerStateSubscription.cancel();
    player.dispose(); // Dispose the player here
    super.dispose();
  }

  void play(String audioUrl) async {
    if (isPlaying) return;

    try {
      await player.setUrl(audioUrl);
      player.play();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void pause() {
    player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: Image.asset(
              'assets/mohamed-seddik-el-menchaoui-154.jpg',
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
                      surah,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                      ),
                    ),
                    // Text(
                    //   reciter,
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     color: Colors.white,
                    //     fontFamily: 'Satoshi',
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  width: 120.w,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite,
                      size: 36.sp,
                      color: Appcolors.secondaryColor,
                    )),
              ],
            ),
          ),
          SizedBox(height: 70.h),
          ProgressBar(
            progress: progress,
            duration: player.duration ?? Duration.zero,
            position: player.position,
            onChanged: (value) {
              player.seek(
                  Duration(seconds: value.toInt())); // Seek to new position
            },
          ),
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
                  onPressed: () async {
                    setState(() {
                      isPlaying ? pause() : play(audio);
                    });
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
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
