import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appTheme.dart';
import 'package:noon/data/model/favorites.dart';
import 'package:noon/data/utils/firebaseUtils.dart';
import 'package:noon/presentation/widgets/nowplaying.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Favoritescreen extends StatefulWidget {
  static const String routeName = 'favoritesList';

  const Favoritescreen({super.key});

  @override
  State<Favoritescreen> createState() => _FavoritescreenState();
}

class _FavoritescreenState extends State<Favoritescreen> {
  late Future<List<Favorites>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = FirebaseUtils.fetchFavorites(); // Initialize the Future
  }

  Future<bool> _checkWiFiConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.wifi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.primaryColor,
        centerTitle: true,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Appcolors.whiteColor,
            fontSize: 30.sp,
            fontFamily: Fontstyle.fontname,
          ),
        ),
      ),
      backgroundColor: Appcolors.primaryColor,
      body: FutureBuilder<List<Favorites>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No favorites added.',
                style: TextStyle(color: Appcolors.whiteColor, fontSize: 18),
              ),
            );
          }

          final favorites = snapshot.data!;

          return ListView.separated(
            padding: EdgeInsets.only(top: 20.h),
            separatorBuilder: (context, index) {
              return const Divider(thickness: 1, color: Appcolors.primaryColor);
            },
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];

              return Dismissible(
                key: Key(favorite.surahName),
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Colors.red,
                  ),
                  padding: EdgeInsets.only(right: 20.w),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  FirebaseUtils.removeFavorite(favorite).then((_) {
                    // Update the state to reflect the removed item
                    setState(() {
                      _favoritesFuture =
                          FirebaseUtils.fetchFavorites(); // Refresh the list
                    });
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${favorite.surahName} removed from favorites')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Appcolors.primaryColor,
                    border: Border.all(
                      color: Appcolors.secondaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.0.r),
                  ),
                  child: ListTile(
                    // minLeadingWidth: 10,

                    tileColor: Appcolors.favContiner,
                    title: Text(
                      favorite.surahName,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    subtitle: Text(
                      favorite.reciterName,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Appcolors.secondaryColor,
                      ),
                      onPressed: () async {
                        bool isWiFiConnected = await _checkWiFiConnection();
                        if (isWiFiConnected && favorite.url.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            NowPlaying.routeName,
                            arguments: {
                              'url': favorite.url,
                              'surah': favorite.surahName,
                              'reciter': favorite.reciterName,
                            },
                          );
                        } else {
                          // Show a message if URL is not valid or not connected to Wi-Fi
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isWiFiConnected
                                  ? 'Cannot play ${favorite.surahName}, URL not available'
                                  : 'Please connect to Wi-Fi to play audio'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
