import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/presentation/Screens/Homepage/homepage.dart';

class Nowplaying extends StatefulWidget {
  static const String routeName = 'nowPlaying';
  Nowplaying({super.key});

  @override
  State<Nowplaying> createState() => _NowplayingState();
}

class _NowplayingState extends State<Nowplaying> {
  final player = AudioPlayer();
  bool isPlaying = false;
  late String audio;
  late String surah;
  late String reciter;

  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    audio = arguments['audio'];
    surah = arguments['surah'];
    reciter = arguments['reciter'];
    play(audio);

    player.playerStateStream.listen((state) {
      if (state.playing == false) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  void dispose() {
    player.dispose();
    super.dispose();
  }

  void play(audio) async {
    if (isPlaying) return;

    if (player.audioSource == null) {
      await player.setUrl(audio);
    }

    player.play();
    setState(() {
      isPlaying = true;
    });
  }

  void pause() {
    player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // play(audio);
    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, Homepage.routeName);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 20.sp,
                    color: Appcolors.whiteColor,
                  )),
              SizedBox(
                width: 100.w,
              ),
              Text(
                'Now playing',
                style: TextStyle(
                    fontSize: 20, color: Colors.white, fontFamily: 'Satoshi'),
              ),
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
                15.r), // Make this a large value for a full circle
            child: Image.asset(
              'assets/mohamed-seddik-el-menchaoui-154.jpg',
              width: 300.0, // Set width and height for the image
              height: 300.0,
              fit: BoxFit.cover, // Ensures the image covers the container
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      surah,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Satoshi'),
                    ),
                    Text(
                      reciter,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Satoshi'),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 70.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    player.setLoopMode(LoopMode.one);
                  },
                  icon: Image.asset('assets/Repeate 3.png')),
              IconButton(
                  onPressed: () {}, icon: Image.asset('assets/Previous.png')),
              Container(
                child: IconButton(
                    onPressed: () async {
                      setState(() {
                        isPlaying ? pause() : play(audio);
                      });
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    )),
                height: 70.h,
                width: 70.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: Appcolors.ButtonColor),
              ),
              IconButton(
                  onPressed: () {
                    player.seekToNext();
                  },
                  icon: Image.asset('assets/Next.png')),
              IconButton(
                  onPressed: () {
                    player.shuffle();
                  },
                  icon: Image.asset('assets/Shuffle 2.png'))
            ],
          )
        ],
      ),
    );
  }
}
