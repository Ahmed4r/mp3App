import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import 'package:noon/appTheme.dart';
import 'package:noon/data/sharedpref/sharedprefUtils.dart';
import 'package:noon/data/userprovider.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageCubit.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageStates.dart';
import 'package:noon/presentation/Screens/Homepage/showSur/showsurah.dart';
import 'package:noon/presentation/Screens/splashScreen/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatelessWidget {
  static const String routeName = 'homepage';
  Homepage({super.key});

  final player =
      AudioPlayer(); // Remember to dispose of this in a StatefulWidget

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => Homepagecubit()..getRecitersData(),
      child: BlocBuilder<Homepagecubit, Homepagestates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Appcolors.ButtonColor,
              centerTitle: true,
              title: Text(
                'Reciters',
                style: TextStyle(
                  color: Appcolors.whiteColor,
                  fontSize: 30.sp,
                  fontFamily: Fontstyle.fontname,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Sharedprefutils.removeData(key: 'usertoken');
                  // Reset state before navigating
                  context.read<Homepagecubit>().resetState();
                  Navigator.pushReplacementNamed(
                      context, Splashscreen.routeName);
                },
                icon: Icon(
                  Icons.logout,
                  size: 25.sp,
                  color: Appcolors.whiteColor,
                ),
              ),
            ),
            backgroundColor: const Color(0xff1C1B1B),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  state is HomepageLoadingState
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 20),
                              Text(
                                'Fetching reciters... 🔎',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : state is HomepageSuccessState &&
                              state.response.reciters?.isEmpty == true
                          ? Center(
                              child: Text(
                                'No reciters available at the moment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: Fontstyle.fontname,
                                  fontSize: 16.sp,
                                ),
                              ),
                            )
                          : state is HomepageSuccessState
                              ? SizedBox(
                                  height: 700.h,
                                  child: ListView.builder(
                                    itemCount:
                                        state.response.reciters?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final reciter =
                                          state.response.reciters![index];

                                      String reciterName =
                                          reciter.name ?? 'Unknown Reciter';

                                      // Check for null moshaf
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: Card(
                                          shadowColor: Appcolors.secondaryColor,
                                          color: const Color(0xff2C2C2C),
                                          child: ListTile(
                                            title: Text(
                                              reciterName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: Fontstyle.fontname,
                                                fontSize: 20.sp,
                                              ),
                                            ),
                                            // trailing: const Icon(
                                            //   Icons.open_in_full,
                                            //   color: Colors.green,
                                            // ),
                                            onTap: () {
                                              // Check if moshaf exists
                                              if (reciter.moshaf != null &&
                                                  reciter.moshaf!.isNotEmpty) {
                                                Navigator.pushNamed(context,
                                                    Showsurah.routeName,
                                                    arguments: {
                                                      'reciter': reciterName,
                                                      'mp3list':
                                                          reciter.moshaf![0],
                                                      'surahList': reciter
                                                          .moshaf![0].surahList
                                                    });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'No surah data available for this reciter'),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Failed to load reciters\ncheck wifi connection 🛜',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontFamily: Fontstyle.fontname,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<Homepagecubit>()
                                              .getRecitersData();
                                        },
                                        child: Text('Retry'),
                                      ),
                                    ],
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
