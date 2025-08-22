import 'package:flutter/material.dart';
import 'package:noon/presentation/Screens/Discovry/DiscoveryScreen.dart';
import 'package:noon/presentation/Screens/Homepage/homepage.dart';
import 'package:noon/presentation/Screens/favorites/favorites.dart';
import 'package:noon/presentation/donwload.dart';

class Bottomnavbar extends StatefulWidget {
  static const String routeName = 'nav';

  const Bottomnavbar({super.key});
  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int currentIndex = 0;
  List<Widget> screens = [
    Homepage(),
    SearchScreen(),
    Favoritescreen(),
    DownloadScreen()
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343434),
      body: screens[currentIndex],
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff343434),
        currentIndex: currentIndex,
        
        onTap: onTap,
        selectedItemColor: const Color(0xff699B88),
        unselectedItemColor: Colors.grey, // Set to a visible color
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/Home.png'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/Discovery.png',
            ),
            label: 'Discovry',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/Heart.png'),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/download.png',
              color: Color(0xff636363),
              scale: 17,
            ),
            // Icon(
            //   Icons.download_outlined,
            //   color: const Color(0xff636363),
            //   size: 31.sp,
            // ),
            label: 'Download',
          ),
        ],
      ),
    );
  }
}
