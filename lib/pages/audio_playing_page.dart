import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_/custom_widgets/record.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayingPage extends StatefulWidget {
  const AudioPlayingPage({super.key, required this.item});
  final SongModel item;

  @override
  State<AudioPlayingPage> createState() => _AudioPlayingPageState();
}

class _AudioPlayingPageState extends State<AudioPlayingPage>
    with TickerProviderStateMixin {
  AudioPlayer player = AudioPlayer();

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isLoaded = false;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setSong(widget.item.uri);
    _controller.addListener(() {
      setState(() {
        position = player.position;
      });
    });
    super.initState();
  }

  setSong(String? uri) async {
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      player.play();
      setState(() {
        isLoaded = true;
        isPlaying = true;
        duration = player.duration!;
        position = player.position;
      });
    } on Exception {
      log("Error parsing song");
      isLoaded = false;
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(46, 46, 94, 1.0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.item.displayName),
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: Center(child: const CircularProgressIndicator()),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RecordWidget(
                controller: _controller,
              ),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration)),
                ],
              ),
              CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon:
                      Icon(isPlaying ? Icons.pause : Icons.play_arrow_outlined),
                  iconSize: 50,
                  onPressed: () async {
                    if (!isPlaying) {
                      print("music on");
                      player.play();
                      setState(() {
                        _controller.repeat();
                        isPlaying = true;
                        position = player.position;
                      });
                    } else {
                      player.pause();
                      setState(() {
                        isPlaying = false;
                        _controller.stop();
                        position = player.position;
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
