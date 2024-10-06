import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noon/appTheme.dart';
import 'package:noon/data/model/favorites.dart';
import 'package:noon/data/utils/firebaseUtils.dart';

class NowPlaying extends StatefulWidget {
  static const String routeName = 'nowPlaying';
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  final player = AudioPlayer();
  bool isLooped = false;
  bool isPlaying = false;
  bool isInitialized = false;
  String? errorMessage;
  bool isfav = false; // Favorite state

  @override
  void initState() {
    super.initState();
    player.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false; // Update playing state when playback completes
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

      String surahName = args?['surah'] ?? '';
      String reciterName = args?['reciter'] ?? '';

      checkIfFavorite(surahName, reciterName);
      _initializePlayer(); 
      isInitialized = true;
    }
  }

  Future<void> checkIfFavorite(String surahName, String reciterName) async {
    try {
      final favorites = await FirebaseUtils.fetchFavorites();
      setState(() {
        isfav = favorites.any((fav) =>
            fav.surahName == surahName && fav.reciterName == reciterName);
      });
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  Future<void> _initializePlayer() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    String url = args?['url'] ?? '';
    String surahName = args?['surah'] ?? '';
    String reciter = args?['reciter'] ?? '';

    if (url.isNotEmpty) {
      try {
        await player.setAudioSource(AudioSource.uri(
          Uri.parse(url),
          tag: MediaItem(
            id: '1',
            album: surahName,
            title: reciter,
            artUri: Uri.parse(url),
          ),
        ));
        player.play(); // Automatically play the audio
        setState(() {
          isPlaying = true; // Update the playing state
        });
      } catch (e) {
        setState(() {
          errorMessage =
              "We are experiencing data corruption with this reciter's audio files.";
        });
        print('Error playing audio: $e');
      }
    } else {
      setState(() {
        errorMessage = 'No valid audio URL found.';
      });
    }
  }

  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? player.play() : player.pause();
    });
  }

  void toggleLoop() {
    setState(() {
      isLooped = !isLooped;
      player.setLoopMode(isLooped ? LoopMode.one : LoopMode.off);
    });
  }

  void seekTo(double value) {
    try {
      final position = Duration(milliseconds: value.toInt());
      // Seek to the position in your media player
      player.seek(position);
    } catch (e) {
      print("Error seeking to position: $e");
    }
  }

  Future<void> toggleFavorite(
      String url, String surahName, String reciter) async {
    setState(() {
      isfav = !isfav; // Toggle favorite state
    });

    if (isfav) {
      // Add to favorites
      await FirebaseUtils.addSurahToFirestore(
        Favorites(
          surahName: surahName,
          reciterName: reciter,
          url: url, // Pass the URL here
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$surahName by $reciter added to favorites'),
        ),
      );
    } else {
      // Remove from favorites
      await FirebaseUtils.removeFavorite(
          Favorites(surahName: surahName, reciterName: reciter, url: url));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('$surahName by $reciter removed from favorites')),
      );
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void replayAudio() {
    seekTo(0.0); // Seek to the start of the audio
    player.play(); // Start playing the audio again
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    String reciter = args?['reciter'] ?? 'No reciter found';
    String surahName = args?['surah'] ?? 'No Surah found';
    String url = args?['url'] ?? ''; // Get the URL from the arguments

    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
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
               
                args?['artUri'] ??
                    'https://i.pinimg.com/236x/81/0c/57/810c57e04d0143df559f3fbfcf382baa.jpg',
                width: 300.0.w,
                height: 300.0.h,
                fit: BoxFit.contain,
                scale: 3,
              ),
            ),
            // SizedBox(height: 40.h),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  // SizedBox(
                  //   width: 100.w,
                  // ),
                  IconButton(
                    onPressed: () {
                      // Call the toggleFavorite function when pressed
                      toggleFavorite(url, surahName, reciter);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: isfav ? Colors.red : Appcolors.whiteColor,
                      size: 30.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Progress Bar
            if (!isInitialized)
              const CircularProgressIndicator()
            else
              StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration = player.duration ?? Duration.zero;
        
                  return Column(
                    children: [
                      Slider(
                        activeColor: Appcolors.secondaryColor,
                        value: position.inMilliseconds.toDouble(),
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble() ??
                            0.0, // Ensure duration is not null
                        onChanged: (value) {
                          // Check if the value is close to the maximum value
                          if (value >=
                              (duration.inMilliseconds.toDouble() ?? 0.0) - 1) {
                            // If it's at the end, seek to the end and replay the audio
                            seekTo(duration.inMilliseconds.toDouble() ?? 0.0);
                            replayAudio();
                          } else {
                            // Otherwise, just seek to the new position
                            seekTo(value);
                          }
                        },
                      ),
                      Text(
                        '${position.toString().split('.').first} / ${duration.toString().split('.').first}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                },
              ),
            SizedBox(height: 30.h),
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
                      onPressed: togglePlay,
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
