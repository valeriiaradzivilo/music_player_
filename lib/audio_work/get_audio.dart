import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_/classes/app_colors.dart';
import 'package:music_player_/classes/music_funcs.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../custom_widgets/text_customized_white.dart';

FutureBuilder<List<SongModel>> getMusic(
    AppColors appColors, MusicFuncs musicFuncs, AudioPlayer? player, _audioQuery,List<SongModel>? songs ) {
  return FutureBuilder<List<SongModel>>(
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
        return Column(
          children: const [
            Center(
                child: TextZip(
                    "No songs found\nDo you want to choose what to listen to?")),
          ],
        );
      }
      if (songs == null && item.data != null) {
        songs?.clear();
        songs?.addAll(item.data!);
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
                    color: const Color.fromRGBO(0, 0, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.play_arrow_outlined),
                        ),
                        title: TextZip(item.data![index].displayNameWOExt),
                        subtitle: TextZip(item.data![index].artist.toString()),
                        tileColor: appColors.darkPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onTap: () {
                          if (player != null) {
                            player.stop();
                          }
                          musicFuncs = MusicFuncs(context, item.data!,
                              item.data!.elementAt(index), player);

                          musicFuncs.chooseMusic();
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
  );
}
