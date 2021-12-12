import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:youtube_demo/data/vos/song_vo.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class LibraryBloc extends ChangeNotifier {
  List<SongVo> allSongs = [];
  DownloadTask? currenDownloadTask;

  void addSong(SearchVideo song) {
    // TODO: communicate with model to persist data
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

  void removeSong(String id) {
    allSongs.removeWhere((song) => song.id == id);
    notifyListeners();
  }

  void setFilePath(String id, String path) {
    print("song downloaded: $path");
    allSongs.firstWhere((song) => song.id == id).filePath = path;
  }

  void downloadSong(String url, String id) {
    currenDownloadTask = DownloadTask(id, false);
    final fileStream = DefaultCacheManager().getFileStream(url);
    fileStream.listen((event) {
      if (event is FileInfo) {
        // downloading is completed
        // TODO: communicate with model to persist data
        setFilePath(id, event.file.path);
        currenDownloadTask?.isFinished = true;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void clearDownload() {
    currenDownloadTask = null;
    notifyListeners();
  }
}

class DownloadTask {
  final String id;
  bool isFinished;

  DownloadTask(this.id, this.isFinished);
}
