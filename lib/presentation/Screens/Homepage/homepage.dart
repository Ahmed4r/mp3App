import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_app/appTheme.dart';

import 'package:mp3_app/presentation/Screens/Homepage/cubit/homepageCubit.dart';
import 'package:mp3_app/presentation/Screens/Homepage/cubit/homepageStates.dart';
import 'package:mp3_app/presentation/Screens/Homepage/search.dart';
import 'package:mp3_app/presentation/Screens/Homepage/cubit/showSur/showsurah.dart';
import 'package:mp3_app/presentation/playScreen/playScreen.dart';
import 'package:mp3_app/presentation/widgets/nowplaying.dart';

class Homepage extends StatelessWidget {
  static const String routeName = 'homepage';
  Homepage({super.key});

  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Homepagecubit()..getRecitersData(),
      child: BlocBuilder<Homepagecubit, Homepagestates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xff1C1B1B),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Search.routeName);
                        },
                        icon: Icon(
                          Icons.search_outlined,
                          size: 30.sp,
                          color: Appcolors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    'القراء',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: Fontstyle.fontname,
                      fontSize: 30.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  state is HomepageLoadingState
                      ? const Center(child: CircularProgressIndicator())
                      : state is HomepageSuccessState
                          ? SizedBox(
                              height: 700.h,
                              child: ListView.builder(
                                itemCount: state.response.reciters?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final reciter =
                                      state.response.reciters![index];

                                  String reciterName =
                                      reciter.name ?? 'No Name';
                                  String SurahId =
                                      reciter.id.toString() ?? 'No Name';

                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Card(
                                      color: const Color(0xff2C2C2C),
                                      child: ListTile(
                                        title: Text(
                                          reciterName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: Fontstyle.fontname,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        trailing: const Icon(
                                          Icons.open_in_full,
                                          color: Colors.green,
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Showsurah.routeName,
                                              arguments: {
                                                'reciter':reciterName,
                                                'mp3list': reciter.moshaf![0],
                                                'surahList':
                                                    reciter.moshaf![0].surahList
                                              });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
