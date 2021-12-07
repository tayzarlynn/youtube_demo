import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_demo/data/model/model.dart';
import 'package:youtube_demo/data/model/model_impl.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeBloc extends ChangeNotifier {
  ///model
  final Model _model = ModelImpl();

  ///state
  List<SearchVideo>? searchVideos;

  void onSearchTextChanged(String value) {
    EasyDebounce.debounce('my-debounce', const Duration(milliseconds: 500),
        () => _searchSong(value));
  }

  void _searchSong(String query) {
    _model.getQuerySearchVideos(query).then((value) {
      searchVideos = value;
      notifyListeners();
    });
  }

  Future<String> onTapSong(String id) {
    /// parsing audio or video
    return YoutubeExplode()
        .videos
        .streamsClient
        .getManifest(id)
        //.then((value) => value.audioOnly.withHighestBitrate().url.toString()); /// get audio url link with webm format
        .then((value) => value.muxed
            .withHighestBitrate()
            .url
            .toString()); // get video url link
  }
}
