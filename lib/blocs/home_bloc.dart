import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
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

  Future<String> onTapSong(String id) async {
    List<String> _urls = [];
    final StreamManifest manifest =
        await YoutubeExplode().videos.streamsClient.getManifest(id);
    for (final AudioStreamInfo i in manifest.audioOnly) {
      _urls.add(i.url.toString()); //add all url with different codec
    }
    return Future.value(_urls[0]); //get the highest codec with mp4 format
  }
}
