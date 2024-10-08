// audioTask.dart

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer _player = AudioPlayer();

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    final String url = params?['url'] ?? '';
    if (url.isNotEmpty) {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      _player.play();
      _updateMediaItem();
    }
  }

  void _updateMediaItem() {
    AudioServiceBackground.setMediaItem(MediaItem(
      id: '1',
      album: 'Album Name',
      title: 'Track Title',
      artUri: Uri.parse('URL to Art'), // You can pass the art URI here
    ));
  }

  @override
  Future<void> onStop() async {
    await _player.stop();
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    await _player.play();
    _updateMediaItem();
  }

  @override
  Future<void> onPause() async {
    await _player.pause();
    _updateMediaItem();
  }

  @override
  void onComplete() {
    // Handle completion if needed
  }
}
