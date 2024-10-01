import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noon/appTheme.dart';


class Nowplaying extends StatefulWidget {
  static const String routeName = 'nowPlaying';
  const Nowplaying({super.key});

  @override
  State<Nowplaying> createState() => _NowplayingState();
}

class _NowplayingState extends State<Nowplaying> {
  final player = AudioPlayer();
  bool islooped = false;
  bool isPlaying = false; // Track playback state
  bool isInitialized = false; // Flag to track if player is initialized
  String? errorMessage; // To store error messages if any

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      _initializePlayer(); // Initialize player only once
      isInitialized = true; // Set the flag to true
    }
  }

  void _initializePlayer() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;
    String url = args?['url'] ?? '';
    String surahName = args?['surah'] ?? '';
    String reciter = args?['reciter'] ?? '';

    if (url.isNotEmpty) {
      try {
        await player.setUrl(url); // Set the audio URL
        player.play(); // Automatically play the audio
        setState(() {
          isPlaying = true; // Update the playing state
        });
      } catch (e) {
        // Handle any errors in loading the audio
        setState(() {
          errorMessage = 'Unable to play the audio. Please try again.';
        });
        print('Error playing audio: $e');
      }
    } else {
      // Handle case when URL is empty
      setState(() {
        errorMessage = 'No valid audio URL found.';
      });
    }
  }

  @override
  void dispose() {
    player.dispose(); // Dispose of the player when the widget is removed
    super.dispose();
  }

  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying; // Toggle the playing state
      isPlaying ? player.play() : player.pause(); // Play or pause the audio
    });
  }

  void looped() {
    setState(() {
      islooped = !islooped; // Toggle loop state
      islooped
          ? player.setLoopMode(LoopMode.one)
          : player.setLoopMode(LoopMode.off);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    String reciter = args?['reciter'] ?? 'No reciter found';
    String surahName = args?['surah'] ?? 'No Surah found';

    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: Column(
        children: [
          SizedBox(height: 40.h),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
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
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Satoshi',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 70.h),
          // Error message
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          // Playback controls
          if (errorMessage == null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: Appcolors.ButtonColor,
                  ),
                  child: IconButton(
                    onPressed: togglePlay, // Toggle play/pause
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
