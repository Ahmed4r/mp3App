import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noon/appTheme.dart';


class Profilescreen extends StatelessWidget {
  static const String routeName = 'profile';
  const Profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 60.h,
          ),
          Text(
            'profile section will added soon',
            style: TextStyle(color: Colors.white, fontSize: 28.sp),
          )
        ],
      ),
    );
  }
}
