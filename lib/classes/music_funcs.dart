import 'dart:developer';
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
  chooseMusic(){
    if(oldPlayer!=null)
      {
        oldPlayer!.stop();
      }
    oldPlayer = AudioPlayer();
    setNewPlayer(songsList!.indexOf(currentSong));
    Navigator.of(context).pushReplacement(_createSlidingRoute());
  }

  // create animation when sliding from bottom line to big audio playing screen
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


  // play song from player
  playSong(AudioPlayer player) {
    player.play();
  }

  //pause song from player
  pauseSong(AudioPlayer player) {
    player.pause();
  }

  // choose which song to play next (alphabetic order)
  // TODO: implement random or cyclic order
  int chooseNextSong() {
    int itemPosition = songsList!.indexOf(currentSong);
    int newItemPosition = 0;
    itemPosition == songsList!.length - 1
        ? newItemPosition = 0
        : newItemPosition = itemPosition + 1;
    return newItemPosition;
  }

  // choose song to play if we press on button play previous song
  int choosePreviousSong() {
    int itemPosition = songsList!.indexOf(currentSong);
    int newItemPosition = 0;
    itemPosition == 0
        ? newItemPosition = songsList!.length - 1
        : newItemPosition = itemPosition - 1;
    return newItemPosition;
  }

  // play next song + open audio_playing_page
  playNextSongNChooseMusic() {
    int newItemPosition = chooseNextSong();
    currentSong = songsList!.elementAt(newItemPosition);
    setNewPlayer(newItemPosition);
    chooseMusic();
  }

  // play previous song + open audio_playing_page
  playPreviousSongNChooseMusic() {
    int newItemPosition = choosePreviousSong();
    currentSong = songsList!.elementAt(newItemPosition);
    setNewPlayer(newItemPosition);
    chooseMusic();
  }

  // set new player with next or previous song
  setNewPlayer(int newItemPosition) async {
    currentSong = songsList!.elementAt(newItemPosition);
    oldPlayer!.pause();
    await oldPlayer!.setAudioSource(AudioSource.uri(
      Uri.parse(currentSong.uri!),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '${currentSong.id}',
        // Metadata to display in the notification:
        album: '${currentSong.artist}',
        title: currentSong.displayNameWOExt,
        artUri: Uri.parse(
            'https://i.pinimg.com/236x/75/44/39/75443963a53bfcf1a0d7f32ba8c7fcdb.jpg'),
      ),
    ));
    oldPlayer!.play();
  }

  // play next song in small line
  playNextSong() async {
    int newItemPosition = chooseNextSong();
    setNewPlayer(newItemPosition);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SongsListPage(
                songModelItem: currentSong,
                player: oldPlayer,
                songs: songsList)));
  }

  //play previous song in small line
  playPreviousSong() async {
    int newItemPosition = choosePreviousSong();
    setNewPlayer(newItemPosition);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SongsListPage(
                songModelItem: currentSong,
                player: oldPlayer,
                songs: songsList)));
  }
}
