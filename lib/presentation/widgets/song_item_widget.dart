import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_demo/blocs/home_bloc.dart';
import 'package:youtube_demo/blocs/library_bloc.dart';
import 'package:youtube_demo/data/vos/song_vo.dart';
import 'package:provider/provider.dart';

class SongItemWidget extends StatelessWidget {
  final SongVo song;

  const SongItemWidget({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // if song is not downloaded, stream it
        // if song is downloaded, play it using downloaded file
        if (song.filePath != null) {
          final player = AudioPlayer();
          await player.setFilePath(song.filePath!);
          player.play();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 16, top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                song.thumbnail.toString(),
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (song.filePath != null) const Icon(Icons.download_for_offline_rounded),
            Selector<LibraryBloc, DownloadTask?>(
              selector: (_, libraryBloc) => libraryBloc.currenDownloadTask,
              builder: (_, downloadTask, __) {
                if (downloadTask == null) {
                  return const SizedBox();
                }
                if (downloadTask.id != song.id) {
                  return const SizedBox();
                }
                if (downloadTask.isFinished) {
                  return const SizedBox();
                }
                return const CircularProgressIndicator();
              },
            ),
            PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case 0:
                    context.read<LibraryBloc>().removeSong(song.id);
                    break;
                  case 1:
                    print("remove form download");
                    break;
                  case 2:
                    final link = await context.read<HomeBloc>().getSongLink(song.id);
                    context.read<LibraryBloc>().downloadSong(link, song.id);
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Text("Remove from Library"),
                ),
                if (song.filePath != null)
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Remove from Download"),
                  ),
                if (song.filePath == null)
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Download"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
