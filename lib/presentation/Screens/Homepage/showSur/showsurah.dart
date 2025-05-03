
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appColors.dart';

// import 'package:noon/appTheme.dart';
import 'package:noon/data/model/favorites.dart';
import 'package:noon/data/model/reciterResponse.dart';
import 'package:noon/data/utils/firebaseUtils.dart';

import 'package:noon/presentation/Screens/Homepage/showSur/cubit/showsurCubit.dart';
import 'package:noon/presentation/Screens/Homepage/showSur/cubit/showsurStates.dart';
import 'package:noon/presentation/widgets/nowplaying.dart';

import 'package:permission_handler/permission_handler.dart';

class Showsurah extends StatefulWidget {
  static const String routeName = 'showsur';

  const Showsurah({super.key});

  @override
  State<Showsurah> createState() => _ShowsurahState();
}

class _ShowsurahState extends State<Showsurah> {
  late Future<List<Favorites>> favoritesList;
  Map<String, bool> favoriteStatusMap = {};

  Future<bool> checkIfFavorite(String surahName, String reciter) async {
    try {
      final favorites = await FirebaseUtils.fetchFavorites();
      return favorites.any(
          (fav) => fav.surahName == surahName && fav.reciterName == reciter);
    } catch (e) {
      print('Error fetching favorites: $e');
      return false; // Consider it not favorite if there's an error
    }
  }

  @override
  void initState() {
    super.initState();
    favoritesList = FirebaseUtils.fetchFavorites(); // Pre-fetch favorites list
  }

  Future<bool> toggleFavorite(
      String url, String surahName, String reciter) async {
    bool isFav =
        favoriteStatusMap[surahName] ?? false; // Get current favorite status
    favoriteStatusMap[surahName] = !isFav; // Optimistically update the UI state

    setState(() {}); // Trigger a rebuild to update the favorite icon

    try {
      if (isFav) {
        // Remove from favorites
        await FirebaseUtils.removeFavorite(
            Favorites(surahName: surahName, reciterName: reciter, url: url));
      } else {
        // Add to favorites
        await FirebaseUtils.addSurahToFirestore(
            Favorites(surahName: surahName, reciterName: reciter, url: url));
      }
      return !isFav; // Return the new favorite status
    } catch (e) {
      print('Error toggling favorite: $e');
      favoriteStatusMap[surahName] = isFav; // Revert back on error
      setState(() {}); // Trigger a rebuild to revert the UI
      return false; // Default to false if there's an error
    }
  }

  Future<void> requestStoragePermission(BuildContext context, String url,
      String surahName, String reciter) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      // If permission is granted, start downloading the file
      downloadFile(context, url, surahName, reciter);
    } else if (status.isDenied) {
      // If permission is denied, show a snackbar with a warning
      final snackBar = SnackBar(
        content: Text('Storage permission is required to download files.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (status.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      openAppSettings();
    }
  }

  void downloadFile(BuildContext context, String url, String surahName,
      String reciter) async {
    try {
      FileDownloader.downloadFile(
        notificationType: NotificationType.all,
        downloadService: DownloadService.downloadManager,
        url: url,
        name: "$surahName $reciter",
        subPath: "/QuranMp3",
        onProgress: (String? fileName, double? progress) {
          print('FILE $fileName HAS PROGRESS $progress');
        },
        onDownloadCompleted: (String path) {
          print('FILE DOWNLOADED TO PATH: $path');
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.fixed,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Done',
              message: 'File has been Downloaded Successfully',
              contentType: ContentType.success,
            ),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        },
        onDownloadError: (String error) {
          print('DOWNLOAD ERROR: $error');
        },
      );
    } catch (e) {
      print("Download failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>? ??
            {};
    final Moshaf? moshaf = args['mp3list'] is Moshaf ? args['mp3list'] : null;
    final String reciter = args['reciter'] ?? 'Unknown Reciter';

    return BlocProvider(
      create: (context) => ShowsurCubit()..getSwarData(),
      child: BlocBuilder<ShowsurCubit, Showsurstates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xff1C1B1B),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                if (state is ShowsurLoadingstates) ...[
                  const Center(
                      child: CircularProgressIndicator(
                          color: Appcolors.whiteColor)),
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
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.home,
                              color: Appcolors.secondaryColor, size: 30.sp),
                        ),
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
                                    fontSize: 22.sp),
                              ),
                              subtitle: Text(
                                surahId.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontFamily: Fontstyle.fontname),
                              ),
                              leading: IconButton(
                                onPressed: () async {
                                  await requestStoragePermission(
                                      context, url, surahName, reciter);
                                },
                                icon: Icon(Icons.download, color: Colors.white),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  bool newState = await toggleFavorite(
                                      url, surahName, reciter);
                                  favoriteStatusMap[surahName] = newState;
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: favoriteStatusMap[surahName] == true
                                      ? Colors.red
                                      : Colors.white,
                                  size: 32.r,
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
                          fontSize: 18.sp),
                    ),
                  )
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
