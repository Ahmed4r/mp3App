import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import 'package:noon/appTheme.dart';
import 'package:noon/data/sharedpref/sharedprefUtils.dart';
import 'package:noon/presentation/Screens/AuthScreen/login.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageCubit.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageStates.dart';
import 'package:noon/presentation/Screens/Homepage/showSur/showsurah.dart';

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
                          Sharedprefutils.removeData(key: 'usertoken');
                          Navigator.pushReplacementNamed(
                              context, Login.routeName);
                        },
                        icon: Icon(
                          Icons.logout,
                          size: 25.sp,
                          color: Appcolors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    'Reciters',
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
                                                'reciter': reciterName,
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
