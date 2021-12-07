import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_demo/blocs/player_bloc.dart';

class PlayerPage extends StatelessWidget {
  final String url;
  const PlayerPage({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlayerBloc(url),
      child: Consumer<PlayerBloc>(
        builder: (context, bloc, _) => Scaffold(
          body: Center(
            child: Text(url),
          ),
        ),
      ),
    );
  }
}
