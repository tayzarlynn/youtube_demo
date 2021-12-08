import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'package:youtube_demo/blocs/downloader_bloc.dart';

class DownloadPage extends StatelessWidget {
  final String url;
  const DownloadPage({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DownloaderBloc(),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<DownloaderBloc>(
            builder: (_, downloaderBloc, __) {
              if (downloaderBloc.fileStream == null) {
                return Container();
              }
              return StreamBuilder<FileResponse>(
                stream: downloaderBloc.fileStream,
                builder: (_, snapshot) {
                  Widget body;
                  if (snapshot.hasError) {
                    body = ListTile(
                      title: const Text('Error'),
                      subtitle: Text(snapshot.error.toString()),
                    );
                  } else if (!snapshot.hasData) {
                    body = const Text("Requesting file info...");
                  } else if (snapshot.data is DownloadProgress) {
                    body = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: CircularProgressIndicator(
                            value: (snapshot.data as DownloadProgress).progress,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        const Text('Downloading'),
                      ],
                    );
                  } else {
                    final fileinfo = snapshot.data as FileInfo;
                    body = Column(
                      children: [
                        ListTile(
                          title: const Text("Local File Path"),
                          subtitle: Text(fileinfo.file.path),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final player = AudioPlayer();
                            await player.setFilePath(fileinfo.file.path);
                            player.play();
                          },
                          child: const Text("Play"),
                        ),
                      ],
                    );
                  }
                  return Center(child: body);
                },
              );
            },
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => context.read<DownloaderBloc>().downloadFile(url),
            child: const Icon(Icons.cloud_download),
          ),
        ),
      ),
    );
  }
}
