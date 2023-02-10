import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_/pages/songs_list_page.dart';
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

  playNextSongNChooseMusic() {
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

  playPreviousSongNChooseMusic() {
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

  playNextSong() async {
    int itemPosition = songsList!.indexOf(currentSong);
    int newItemPosition = 0;
    itemPosition == songsList!.length - 1
        ? newItemPosition = 0
        : newItemPosition = itemPosition + 1;
    currentSong = songsList!.elementAt(newItemPosition);
    oldPlayer?.stop();
    oldPlayer = AudioPlayer();
    await oldPlayer
        ?.setAudioSource(
        AudioSource.uri(
          Uri.parse(currentSong.uri!),
          tag: MediaItem(
            // Specify a unique ID for each media item:
            id: '${currentSong.id}',
            // Metadata to display in the notification:
            album: '${currentSong.artist}',
            title: '${currentSong.displayNameWOExt}',
            artUri: Uri.parse('https://i.pinimg.com/236x/75/44/39/75443963a53bfcf1a0d7f32ba8c7fcdb.jpg'),
          ),
        ));
    oldPlayer!.play();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>SongsListPage(songModelItem: currentSong, player: oldPlayer, songs: songsList)));
  }

  playPreviousSong() async{
    int itemPosition = songsList!.indexOf(currentSong);
    int newItemPosition = 0;
    itemPosition == 0
        ? newItemPosition = songsList!.length - 1
        : newItemPosition = itemPosition - 1;
    currentSong = songsList!.elementAt(newItemPosition);
    oldPlayer?.stop();
    oldPlayer = AudioPlayer();
    await oldPlayer?.setAudioSource(
    AudioSource.uri(
    Uri.parse(currentSong.uri!),
    tag: MediaItem(
    // Specify a unique ID for each media item:
    id: '${currentSong.id}',
    // Metadata to display in the notification:
    album: '${currentSong.artist}',
    title: '${currentSong.displayNameWOExt}',
    artUri: Uri.parse('https://i.pinimg.com/236x/75/44/39/75443963a53bfcf1a0d7f32ba8c7fcdb.jpg'),
    ),
    ));
    oldPlayer!.play();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>SongsListPage(songModelItem: currentSong, player: oldPlayer, songs: songsList)));
  }
}
