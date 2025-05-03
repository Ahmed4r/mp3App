import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  MyAudioHandler() {
    // Initialize the player and listen to its state
    _player.playbackEventStream.listen(_broadcastState);
  }

  // Set the media item (track information)
  Future<void> setAudioSource(String url) async {
    await _player.setUrl(url);
  }

  // Override play/pause commands
  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.pause,
        MediaControl.play,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: AudioProcessingState.ready,
      playing: _player.playing,
    ));
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }
}
