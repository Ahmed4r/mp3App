import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
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
  bool isFav = false; // Favorite state

  @override
  void initState() {
    super.initState();
    _setupAudioSession();
    player.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;
      String surahName = args?['surah'] ?? '';
      String reciterName = args?['reciter'] ?? '';
      _checkIfFavorite(surahName, reciterName);
      _initializePlayer(args);
      isInitialized = true;
    }
  }

  Future<void> _checkIfFavorite(String surahName, String reciterName) async {
    try {
      final favorites = await FirebaseUtils.fetchFavorites();
      setState(() {
        isFav = favorites.any((fav) =>
            fav.surahName == surahName && fav.reciterName == reciterName);
      });
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  Future<void> _initializePlayer(Map<dynamic, dynamic>? args) async {
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
        player.play();
        setState(() {
          isPlaying = true;
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

  void _togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        player.play();
      } else {
        player.pause();
      }
    });
  }

  void _toggleLoop() {
    setState(() {
      isLooped = !isLooped;
      player.setLoopMode(isLooped ? LoopMode.one : LoopMode.off);
    });
  }

  void _seekTo(double value) {
    try {
      final position = Duration(milliseconds: value.toInt());
      player.seek(position);
    } catch (e) {
      print("Error seeking to position: $e");
    }
  }

  Future<void> _toggleFavorite(
      String url, String surahName, String reciter) async {
    setState(() {
      isFav = !isFav;
    });

    if (isFav) {
      await FirebaseUtils.addSurahToFirestore(
          Favorites(surahName: surahName, reciterName: reciter, url: url));
      _showSnackBar('$surahName by $reciter added to favorites');
    } else {
      await FirebaseUtils.removeFavorite(
          Favorites(surahName: surahName, reciterName: reciter, url: url));
      _showSnackBar('$surahName by $reciter removed from favorites');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _replayAudio() {
    _seekTo(0.0);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    String reciter = args?['reciter'] ?? 'No reciter found';
    String surahName = args?['surah'] ?? 'No Surah found';
    String url = args?['url'] ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        backgroundColor: Appcolors.primaryColor,
        centerTitle: true,
        title: Text(
          'Now playing',
          style: TextStyle(
              color: Colors.white,
              fontSize: 25.sp,
              fontFamily: Fontstyle.fontname),
        ),
      ),
      backgroundColor: Appcolors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildArtImage(args),
            _buildInfoSection(reciter, surahName, url),
            // SizedBox(height: 20.h),
            _buildPlaybackControls(),
            // SizedBox(height: 30.h),
            if (errorMessage != null) _buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildArtImage(Map<dynamic, dynamic>? args) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.r),
      child: Image.asset(
        args?['artUri'] ?? 'assets/quran-in-english-and-arabic-logo.png',
        filterQuality: FilterQuality.high,
        width: 480.0.w,
        height: 480.0.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildInfoSection(String reciter, String surahName, String url) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reciter,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: Fontstyle.fontname)),
              Text(surahName,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: Fontstyle.fontname)),
            ],
          ),
          IconButton(
            onPressed: () => _toggleFavorite(url, surahName, reciter),
            icon: Icon(Icons.favorite,
                color: isFav ? Colors.red : Appcolors.whiteColor, size: 30.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls() {
    if (!isInitialized) {
      return const CircularProgressIndicator(color: Colors.white);
    } else {
      return StreamBuilder<Duration>(
        stream: player.positionStream,
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;
          final duration = player.duration ?? Duration.zero;
          final maxDuration = duration.inMilliseconds.toDouble();
          final currentPosition = position.inMilliseconds.toDouble();

          return Column(
            children: [
              Slider(
                activeColor: Appcolors.secondaryColor,
                value: currentPosition.clamp(0.0, maxDuration),
                min: 0.0,
                max: maxDuration,
                onChanged: (value) {
                  if (value >= maxDuration - 1) {
                    _seekTo(maxDuration);
                    _replayAudio();
                  } else {
                    _seekTo(value);
                  }
                },
              ),
              Text(
                  '${position.toString().split('.').first} / ${duration.toString().split('.').first}',
                  style: const TextStyle(
                      color: Colors.white, fontFamily: Fontstyle.fontname)),
              _buildControlButtons(),
            ],
          );
        },
      );
    }
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: _toggleLoop,
          icon: Icon(isLooped ? Icons.repeat_one : Icons.repeat,
              color: Appcolors.whiteColor, size: 40.sp),
        ),
        IconButton(
          onPressed: () => _seekTo(0),
          icon: Icon(Icons.replay, color: Appcolors.whiteColor, size: 40.sp),
        ),
        IconButton(
          onPressed: _togglePlay,
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
              color: Appcolors.whiteColor, size: 40.sp),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        errorMessage!,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
