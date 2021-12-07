import 'package:youtube_demo/data/model/model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ModelImpl extends Model{
  @override
  Future<List<SearchVideo>> getQuerySearchVideos(String query) {
   return SearchQuery.search(YoutubeHttpClient(), query).then((value) {
     return  value.content.whereType<SearchVideo>().toList();
   });
  }

}