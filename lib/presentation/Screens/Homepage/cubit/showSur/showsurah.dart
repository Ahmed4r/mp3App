import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/data/model/reciterResponse.dart';
import 'package:mp3_app/presentation/Screens/Homepage/cubit/showSur/cubit/showsurCubit.dart';
import 'package:mp3_app/presentation/Screens/Homepage/cubit/showSur/cubit/showsurStates.dart';
import 'package:mp3_app/presentation/widgets/nowplaying.dart';

class Showsurah extends StatefulWidget {
  static const String routeName = 'showsur';

  const Showsurah({super.key});

  @override
  State<Showsurah> createState() => _ShowsurahState();
}

class _ShowsurahState extends State<Showsurah> {
  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;
    Moshaf moshaf = arg?['mp3list'] ?? 0;
    String surahList = arg?['surahList'] ?? '';
    String reciter = arg?['reciter'] ?? '';
    print('listttttttttttttttttttttt: ${moshaf.server}');
    print(
        'surahhhhhhhhhhlistttttttttttttttttttttt: ${moshaf.surahList.toString()}');
    // final server = moshaf![0];
    // print('serverrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr${moshaf.server![2]}');

    return BlocProvider(
      create: (context) {
        print('Creating ShowsurCubit...');
        return ShowsurCubit()..getSwarData();
      },
      child: BlocBuilder<ShowsurCubit, Showsurstates>(
        builder: (context, state) {
          print('Current State: $state');

          return Scaffold(
              backgroundColor: const Color(0xff1C1B1B),
              body: Column(children: [
                SizedBox(height: 60.h),
                Text(
                  'السور',
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
                  if (state.response.suwar != null &&
                      state.response.suwar!.isNotEmpty) ...[
                    SizedBox(
                      height: 700.h,
                      child: ListView.builder(
                        itemCount: state.response.suwar!.length,
                        itemBuilder: (context, index) {
                          final surah = state.response.suwar![index];
                          String surahName = surah.name ?? 'Surah name unknown';
                          int surahId = surah.id ?? 0;

                          String formattedNumber =
                              surahId.toString().padLeft(3, '0');

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
                                subtitle: Text(surahId.toString()),
                                trailing: IconButton(
                                    onPressed: () {
                                      print(surahId);
                                      AudioPlayer player = AudioPlayer();
                                      player.setUrl(
                                          '${moshaf.server!}/${formattedNumber}.mp3');
                                      player.play();
                                      String url =
                                          '${moshaf.server!}/${formattedNumber}.mp3';
                                      String surah = surahName;
                                      String reciterName = reciter;
                                      Navigator.pushNamed(
                                          context, Nowplaying.routeName,
                                          arguments: {
                                            'url': url,
                                            'reciter': reciterName,
                                            'surah': surahName
                                          });
                                    },
                                    icon: Icon(Icons.play_arrow)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    Center(
                      child: Text(
                        'No reciters found.',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: Fontstyle.fontname,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ] else if (state is ShowsurErrorstates) ...[
                  Center(
                    child: Text(
                      'Failed to load reciters: ${state.ErrorMessage}',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: Fontstyle.fontname,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ]
              ]));
        },
      ),
    );
  }
}
