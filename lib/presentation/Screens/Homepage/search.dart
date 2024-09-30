import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mp3_app/appTheme.dart';


class Search extends StatelessWidget {
  static const String routeName = 'search';
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Appcolors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
