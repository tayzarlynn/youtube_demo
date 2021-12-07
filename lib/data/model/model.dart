import 'package:youtube_explode_dart/youtube_explode_dart.dart';

abstract class Model{
  Future<List<SearchVideo>> getQuerySearchVideos(String query);
}