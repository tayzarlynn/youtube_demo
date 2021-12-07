import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerBloc extends ChangeNotifier {
  late AudioPlayer player;

  PlayerBloc(String url) {
    _init(url);
  }

  ///just testing purpose for playing video
  void _init(String url) async {
    player = AudioPlayer();
    try {
      await player.setUrl(url);
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }
    player.play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
