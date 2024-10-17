import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appColors.dart';
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
  bool _isConnected = false;
  late Future<List<Favorites>> _favoritesFuture;
  List<Favorites> _favoritesList = []; // Local state to store favorites

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _favoritesFuture = _loadFavorites(); // Initialize the Future
  }

  Future<List<Favorites>> _loadFavorites() async {
    _favoritesList = await FirebaseUtils.fetchFavorites();
    return _favoritesList; // Return the loaded favorites
  }

  Future<void> _checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
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
                'Add Your Favorites Here',
                style: TextStyle(
                    color: Appcolors.whiteColor,
                    fontSize: 25,
                    fontFamily: 'Satoshi'),
              ),
            );
          }

          final favorites = snapshot.data!; // Use the data from the snapshot

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
                onDismissed: (direction) async {
                  // Store the index of the dismissed item
                  int dismissedIndex = index;
                  // Remove the item from local state
                  setState(() {
                    _favoritesList.removeAt(dismissedIndex);
                  });

                  // Try to remove from Firestore
                  try {
                    await FirebaseUtils.removeFavorite(favorite);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${favorite.surahName} removed from favorites')),
                    );
                  } catch (error) {
                    // Restore the item if deletion fails
                    setState(() {
                      _favoritesList.insert(dismissedIndex, favorite);
                    });
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //       content:
                    //           Text('Failed to remove ${favorite.surahName}')),
                    // );
                  }
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
                      onPressed: () {
                        Navigator.pushNamed(context, NowPlaying.routeName,
                            arguments: {
                              'url': favorite.url,
                              'surah': favorite.surahName,
                              'reciter': favorite.reciterName,
                            });
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
