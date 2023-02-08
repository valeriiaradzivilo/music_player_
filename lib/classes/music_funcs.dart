import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../pages/audio_playing_page.dart';

class MusicFuncs {
  BuildContext context;
  List<SongModel>? songsList;
  SongModel currentSong;
  AudioPlayer? oldPlayer;

  MusicFuncs(this.context, this.songsList, this.currentSong, this.oldPlayer);

  /// on list tile tap open chosen music file
  chooseMusic() {
    Navigator.of(context)
        .pushReplacement(_createSlidingRoute());
  }

  Route _createSlidingRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AudioPlayingPage(
        item: currentSong,
        songs: songsList,
        oldPlayer: oldPlayer,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  setSong() async {
    oldPlayer = AudioPlayer();
    try {
      await oldPlayer
          ?.setAudioSource(AudioSource.uri(Uri.parse(currentSong.uri!)));
      oldPlayer?.play();
    } on Exception {
      log("Error parsing song");
    }
  }

  playSong(AudioPlayer player) {
    print("music on");
    player.play();
  }

  pauseSong(AudioPlayer player) {
    player.pause();
  }

  playNextSong() {
    int itemPosition = songsList!.indexOf(currentSong);
    int newItemPosition = 0;
    itemPosition == songsList!.length - 1
        ? newItemPosition = 0
        : newItemPosition = itemPosition + 1;
    currentSong = songsList!.elementAt(newItemPosition);
    oldPlayer?.stop();
    oldPlayer = null;
    chooseMusic();
  }

  playPreviousSong() {
    int itemPosition = songsList!.indexOf(currentSong);
    int newItemPosition = 0;
    itemPosition == 0
        ? newItemPosition = songsList!.length - 1
        : newItemPosition = itemPosition - 1;
    currentSong = songsList!.elementAt(newItemPosition);
    oldPlayer?.stop();
    oldPlayer = null;
    chooseMusic();
  }
}
