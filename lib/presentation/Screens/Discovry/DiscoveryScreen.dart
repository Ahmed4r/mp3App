import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import 'package:noon/appTheme.dart';

class DonwloadScreen extends StatefulWidget {
  static const String routeName = 'downloaded';
  DonwloadScreen({super.key});

  @override
  State<DonwloadScreen> createState() => _DonwloadScreenState();
}

class _DonwloadScreenState extends State<DonwloadScreen> {
  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;
    String url = arguments?['url'] ?? '';
    var reciterName = arguments?['reciterName'] ?? '';
    var surahName = arguments?['surahName'] ?? '';

    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40.h,
          ),
          Text(
            '    Download section coming soon',
            style: TextStyle(color: Colors.white, fontSize: 22.sp),
          ),
        ],
      ),
    );
  }
}
