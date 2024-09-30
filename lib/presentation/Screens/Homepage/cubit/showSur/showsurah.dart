import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/data/model/audioReponse.dart';
import 'package:mp3_app/presentation/Screens/Homepage/cubit/showSur/cubit/showsurCubit.dart';
import 'package:mp3_app/presentation/Screens/Homepage/cubit/showSur/cubit/showsurStates.dart';

class Showsurah extends StatefulWidget {
  static const String routeName = 'showsur';

  const Showsurah({super.key});

  @override
  State<Showsurah> createState() => _ShowsurahState();
}

class _ShowsurahState extends State<Showsurah> {
  final AudioPlayer player = AudioPlayer();
  int? currentlyPlayingSurahIndex; // Track the currently playing Surah index

  @override
  void dispose() {
    player.dispose(); // Dispose the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    String reciterId = arg?['reciterId'] ?? 'no id';
    print('Reciter ID: $reciterId');

    return BlocProvider(
      create: (context) {
        print('Creating ShowsurCubit...');
        return ShowsurCubit()..getAudioData(reciterId);
      },
      child: BlocBuilder<ShowsurCubit, Showsurstates>(
        builder: (context, state) {
          print('Current State: $state');

          return Scaffold(
            backgroundColor: const Color(0xff1C1B1B),
            body: Column(
              children: [
                SizedBox(height: 60.h),
                Text(
                  'Sur',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: Fontstyle.fontname,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                if (state is ShowsurLoadingstates) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else if (state is ShowsurSucessstates) ...[
                  if (state.response.data != null &&
                      state.response.data!.surahs != null) ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.response.data!.surahs!.length,
                        itemBuilder: (context, index) {
                          final surah = state.response.data!.surahs![index];
                          String surahName = surah.name ?? 'Surah name unknown';
                          int surahNumber = surah.number ?? 0;

                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Card(
                              color: const Color(0xff2C2C2C),
                              child: ListTile(
                                title: Text(
                                  surahName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: Fontstyle.fontname,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                subtitle: Text(
                                  'Ayahs: ${surah.ayahs?.length ?? 0}', // Display the count of ayahs
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: Fontstyle.fontname,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                trailing: Icon(
                                  currentlyPlayingSurahIndex == index
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.green,
                                ),
                                onTap: () async {
                                  if (currentlyPlayingSurahIndex == index) {
                                    // If the same Surah is tapped, pause or stop playback
                                    await player.stop();
                                    setState(() {
                                      currentlyPlayingSurahIndex =
                                          null; // Reset the playing index
                                    });
                                  } else {
                                    // Play the new Surah
                                    setState(() {
                                      currentlyPlayingSurahIndex =
                                          index; // Set the new playing index
                                    });

                                    if (surah.ayahs != null &&
                                        surah.ayahs!.isNotEmpty) {
                                      for (var ayah in surah.ayahs!) {
                                        try {
                                          await player
                                              .stop(); // Stop any currently playing audio
                                          if (ayah.audio != null &&
                                              ayah.audio!.isNotEmpty) {
                                            await player.setUrl(ayah.audio!);
                                            await player.play();
                                            break; // Exit after starting to play the first ayah
                                          } else {
                                            print(
                                                "Audio URL is empty or null for ayah: ${ayah.number}");
                                          }
                                        } catch (e) {
                                          print(
                                              "Error playing audio for ayah ${ayah.number}: $e");
                                        }
                                      }
                                    } else {
                                      print("No ayahs found for the surah.");
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Text(
                        'Failed to load reciters',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: Fontstyle.fontname,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  Center(
                    child: Text(
                      'Failed to load reciters',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: Fontstyle.fontname,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
