import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_demo/blocs/home_bloc.dart';
import 'package:youtube_demo/blocs/library_bloc.dart';
import 'package:youtube_demo/presentation/pages/library_page.dart';
import 'package:youtube_demo/presentation/pages/player_page.dart';
import 'package:youtube_demo/utils/utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            SearchView(),
            SearchResultListView(),
          ],
        ),
      ),
    );
  }
}

class SearchView extends StatelessWidget {
  const SearchView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bloc, _) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          autofocus: false,
          onChanged: (value) {
            bloc.onSearchTextChanged(value);
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(width: 1.0, color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.0, color: Colors.grey),
              ),
              hintText: 'Songs,artists',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.grey,
              )),
        ),
      ),
    );
  }
}

class SearchResultListView extends StatelessWidget {
  const SearchResultListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bloc, _) => Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) => SearchResultItemView(
                  video: bloc.searchVideos?[index],
                  onTap: (id) => bloc.onTapSong(id).then(
                        (value) => navigateToNextPage(
                          context,
                          PlayerPage(
                            url: value,
                          ),
                        ),
                      ),
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: bloc.searchVideos?.length ?? 0),
      ),
    );
  }
}

class SearchResultItemView extends StatelessWidget {
  final Function(String) onTap;
  final SearchVideo? video;
  const SearchResultItemView({required this.video, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(video?.id.toString() ?? '');
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
                video?.thumbnails[0].url.toString() ?? '',
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
                    video?.title ?? 'Song Title',
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
                    video?.author ?? 'Author',
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
            PopupMenuButton(
              onSelected: (value) {
                print("add song to libary");
                context.read<LibraryBloc>().addSong(video!);
                navigateToNextPage(context, const LibraryPage());
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 1,
                  child: Text("Add to Library"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
