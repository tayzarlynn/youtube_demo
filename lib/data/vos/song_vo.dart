class SongVo {
  String id;
  String title;
  String artist;
  Uri thumbnail;
  String duration;
  String? filePath;

  SongVo({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.duration,
    required this.filePath,
  });
}
