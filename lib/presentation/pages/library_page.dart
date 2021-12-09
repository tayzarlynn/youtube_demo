import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:youtube_demo/blocs/library_bloc.dart';
import 'package:youtube_demo/data/vos/song_vo.dart';
import 'package:youtube_demo/presentation/widgets/song_item_widget.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<LibraryBloc>(
          builder: (context, libraryBloc, child) {
            final allSongs = libraryBloc.allSongs;
            return allSongs.isEmpty ? const Text("No songs yet...") : SongListView(allSongs: allSongs.reversed.toList());
          },
        ),
      ),
    );
  }
}

class SongListView extends StatelessWidget {
  final List<SongVo> allSongs;

  const SongListView({
    Key? key,
    required this.allSongs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: allSongs.length,
      itemBuilder: (_, index) => SongItemWidget(song: allSongs[index]),
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}
