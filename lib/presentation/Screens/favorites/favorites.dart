import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appTheme.dart';
import 'package:noon/data/model/favorites.dart';
import 'package:noon/data/utils/firebaseUtils.dart';
import 'package:noon/presentation/widgets/nowplaying.dart';

class Favoritescreen extends StatefulWidget {
  static const String routeName = 'favoritesList';

  const Favoritescreen({super.key});

  @override
  State<Favoritescreen> createState() => _FavoritescreenState();
}

class _FavoritescreenState extends State<Favoritescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.ButtonColor,
        centerTitle: true,
        title: Text(
          'Favorites ❤️',
          style: TextStyle(
            color: Appcolors.whiteColor,
            fontSize: 30.sp,
            fontFamily: Fontstyle.fontname,
          ),
        ),
      ),
      backgroundColor: Appcolors.primaryColor,
      body: FutureBuilder<List<Favorites>>(
        future: FirebaseUtils.fetchFavorites(),
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

          // List of favorites available
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
                  FirebaseUtils.removeFavorite(favorite);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '${favorite.surahName} removed from favorites')),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Appcolors.darkgreen, // Background color of the ListTile
                    border: Border.all(
                      color: Appcolors.secondaryColor, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ), // Circular border
                  child: ListTile(
                    tileColor: Appcolors.favContiner,
                    title: Text(
                      favorite.surahName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      favorite.reciterName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Appcolors.secondaryColor,
                      ),
                      onPressed: () {
                        if (favorite.url.isNotEmpty) {
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
                          // Show a message if URL is not valid
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Cannot play ${favorite.surahName}, URL not available')),
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
