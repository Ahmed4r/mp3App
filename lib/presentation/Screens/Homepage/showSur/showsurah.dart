import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appTheme.dart';
import 'package:noon/data/model/favorites.dart';
import 'package:noon/data/model/reciterResponse.dart';
import 'package:noon/data/utils/firebaseUtils.dart';
import 'package:noon/presentation/Screens/Homepage/showSur/cubit/showsurCubit.dart';
import 'package:noon/presentation/Screens/Homepage/showSur/cubit/showsurStates.dart';
import 'package:noon/presentation/Screens/favorites/favorites.dart';
import 'package:noon/presentation/widgets/nowplaying.dart';

class Showsurah extends StatefulWidget {
  static const String routeName = 'showsur';

  const Showsurah({super.key});

  @override
  State<Showsurah> createState() => _ShowsurahState();
}

class _ShowsurahState extends State<Showsurah> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>? ??
            {};
    final Moshaf? moshaf = args['mp3list'] is Moshaf ? args['mp3list'] : null;
    final String reciter = args['reciter'] ?? 'Unknown Reciter';

    return BlocProvider(
      create: (context) {
        return ShowsurCubit()..getSwarData();
      },
      child: BlocBuilder<ShowsurCubit, Showsurstates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xff1C1B1B),
            body: Column(
              children: [
                SizedBox(height: 30.h),
                if (state is ShowsurLoadingstates) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else if (state is ShowsurSucessstates) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Suwar you can listen to by \n$reciter',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: Fontstyle.fontname,
                            fontSize: 18.sp,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.home,
                            color: Appcolors.secondaryColor,
                            size: 30.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.response.suwar?.length ?? 0,
                      itemBuilder: (context, index) {
                        final surah = state.response.suwar![index];
                        final String surahName =
                            surah.name ?? 'Surah name unknown';
                        final int surahId = surah.id ?? 0;
                        final String formattedNumber =
                            surahId.toString().padLeft(3, '0');
                        final String url =
                            '${moshaf!.server}/$formattedNumber.mp3';

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
                                  fontSize: 22.sp,
                                ),
                              ),
                              subtitle: Text(
                                surahId.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontFamily: Fontstyle.fontname),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  try {
                                    // Check for missing or empty fields
                                    if (surahName.isEmpty ||
                                        reciter.isEmpty ||
                                        url.isEmpty) {
                                      throw Exception(
                                          "Invalid favorite: Missing or empty fields");
                                    }

                                    // Create the Favorites object
                                    final favorite = Favorites(
                                      surahName: surahName,
                                      reciterName: reciter,
                                      url: url,
                                    );

                                    await FirebaseUtils.addSurahToFirestore(
                                        favorite);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '$surahName added to favorites')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to add to favorites: $e')),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: Appcolors.secondaryColor,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  NowPlaying.routeName,
                                  arguments: {
                                    'server': moshaf.server,
                                    'url': url,
                                    'reciter': reciter,
                                    'surah': surahName,
                                    'id': surahId,
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
