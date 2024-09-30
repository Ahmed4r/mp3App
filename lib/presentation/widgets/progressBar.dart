import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final Duration duration;
  final Duration position;
  final Function(double value) onChanged; // Callback for slider changes

  const ProgressBar({
    super.key,
    required this.progress,
    required this.duration,
    required this.position,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            
            activeColor: const Color(0xff699B88),
            value: progress,
            onChanged: onChanged, // Use the callback to seek
            min: 0.0,
            max: duration.inSeconds.toDouble(),
          ),
        ),
        Text(
          _formatDuration(position),
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        Text(
          '/ ${_formatDuration(duration)}',
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
