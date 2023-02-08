import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_/classes/music_funcs.dart';

import 'package:music_player_/pages/audio_playing_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../classes/app_colors.dart';
import '../classes/bottom_choice.dart';
import '../custom_widgets/small_song_line.dart';
import '../custom_widgets/text_customized_white.dart';

class SongsListPage extends StatefulWidget {
  const SongsListPage(
      {super.key,
      required this.isPlaying,
      required this.songModelItem,
      required this.player});
  final AudioPlayer? player;
  final bool? isPlaying;
  final SongModel? songModelItem;

  @override
  State<SongsListPage> createState() => _SongsListPageState();
}

class _SongsListPageState extends State<SongsListPage> {
  AppColors appColors = AppColors();
  MusicFuncs musicFuncs = MusicFuncs();
  final _audioQuery = OnAudioQuery();
  bool musicIsLoaded = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
    setState(() {
      musicIsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.purple,
      appBar: AppBar(
        title: const Text("Zip player"),
        backgroundColor: appColors.lightPurple,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomAppBar(
        color: appColors.purple,
        elevation: 1,
        child: widget.isPlaying != null ||
                widget.songModelItem != null ||
                widget.player != null
            ? SmallSongLine(
                isPlaying: widget.isPlaying,
                item: widget.songModelItem,
                player: widget.player,
              )
            : const SizedBox(),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(child: TextZip("No songs found"));
          }
          return CustomScrollView(slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Hero(
                      tag: 'music_$index',
                      child: Material(
                        color: Color.fromRGBO(0, 0, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.play_arrow_outlined),
                            ),
                            title: TextZip(item.data![index].displayNameWOExt),
                            subtitle:
                                TextZip(item.data![index].artist.toString()),
                            tileColor: appColors.darkPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onTap: () {
                              if (widget.player != null) {
                                widget.player?.stop();
                              }
                              musicFuncs.chooseMusic(
                                  context, item.data![index], item.data);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: item.data?.length,
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
