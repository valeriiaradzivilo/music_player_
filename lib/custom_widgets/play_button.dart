import 'package:flutter/material.dart';

Padding playButton(bool isPlaying, playSong, stopSong, double size) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
      radius: size,
      child: IconButton(
        icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_outlined),
        iconSize: size,
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
