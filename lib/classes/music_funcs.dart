
import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../pages/audio_playing_page.dart';
class MusicFuncs{
  /// on list tile tap open chosen music file
  chooseMusic(context, SongModel item,List<SongModel>? songs) {
    print("play music {$item.displayName}");
    Navigator.of(context).push(_createSlidingRoute(item, songs));
  }

  Route _createSlidingRoute(SongModel item, List<SongModel>? songs) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AudioPlayingPage(item: item, songs: songs,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }




}