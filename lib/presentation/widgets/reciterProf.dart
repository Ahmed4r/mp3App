import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_app/appTheme.dart';
import 'package:mp3_app/presentation/widgets/nowplaying.dart';

class Reciterprof extends StatelessWidget {
  String audio;
  String imageUrl;
  Reciterprof({required this.audio, required this.imageUrl});
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          30.r), // Make this a large value for a full circle
      child: Image.asset(
        imageUrl,
        width: 170.w, // Set width and height for the image
        height: 170.h,
        fit: BoxFit.fill, // Ensures the image covers the container
      ),
    );
  }
}
