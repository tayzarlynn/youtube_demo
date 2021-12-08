import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DownloaderBloc extends ChangeNotifier {
  Stream<FileResponse>? fileStream;

  void downloadFile(String url) {
    fileStream = DefaultCacheManager().getFileStream(url, withProgress: true);
    notifyListeners();
  }
}
