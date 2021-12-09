import 'package:flutter/material.dart';
import 'package:youtube_demo/data/vos/song_vo.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class LibraryBloc extends ChangeNotifier {
  List<SongVo> allSongs = [];

  void addSong(SearchVideo song) {
    // TODO: communicate with model
    allSongs.add(SongVo(
      id: song.id.value,
      title: song.title,
      artist: song.author,
      thumbnail: song.thumbnails[0].url,
      duration: song.duration,
      filePath: null,
    ));
    notifyListeners();
  }
}
