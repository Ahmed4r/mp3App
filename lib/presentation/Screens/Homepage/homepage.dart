import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noon/appColors.dart';

// import 'package:noon/appTheme.dart';
import 'package:noon/data/sharedpref/sharedprefUtils.dart';
import 'package:noon/presentation/Screens/AuthScreen/login.dart';
import 'package:noon/presentation/Screens/Discovry/DiscoveryScreen.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageCubit.dart';
import 'package:noon/presentation/Screens/Homepage/cubit/homepageStates.dart';
import 'package:noon/presentation/Screens/Homepage/showSur/showsurah.dart';

class Homepage extends StatefulWidget {
  static const String routeName = 'homepage';
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Homepagecubit()..getRecitersData(),
      child: BlocBuilder<Homepagecubit, Homepagestates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Appcolors.primaryColor,
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
                  Navigator.pushReplacementNamed(context, Login.routeName);
                },
                icon: Icon(
                  Icons.logout,
                  size: 25.sp,
                  color: Appcolors.whiteColor,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchScreen.routeName);
                  },
                  icon: Icon(
                    Icons.search,
                    size: 25.sp,
                    color: Appcolors.whiteColor,
                  ),
                ),
              ],
            ),
            backgroundColor: Appcolors.primaryColor,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  state is HomepageLoadingState
                      ? Center(
                          child: SpinKitRing(
                            color: Colors.blueGrey,
                            size: 50.0,
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
                                          color: Appcolors.primaryColor,
                                          child: ListTile(
                                            title: Text(
                                              reciterName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: Fontstyle.fontname,
                                                fontSize: 20.sp,
                                              ),
                                            ),
                                            onTap: () {
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
