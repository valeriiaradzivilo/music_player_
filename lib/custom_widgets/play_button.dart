import 'package:flutter/material.dart';

Padding playButton(bool isPlaying, playSong, stopSong) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
      radius: 35,
      child: IconButton(
        icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_outlined),
        iconSize: 50,
        onPressed: () async {
          if (!isPlaying) {
            playSong();
          } else {
            stopSong();
          }
        },
      ),
    ),
  );
}
