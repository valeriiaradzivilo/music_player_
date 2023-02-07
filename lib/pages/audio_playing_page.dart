import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_/classes/app_colors.dart';
import 'package:music_player_/classes/music_funcs.dart';
import 'package:music_player_/custom_widgets/record.dart';
import 'package:music_player_/custom_widgets/song_name_text.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';

class AudioPlayingPage extends StatefulWidget {
  const AudioPlayingPage({super.key, required this.item, required this.songs});
  final SongModel item;
  final List<SongModel>? songs;

  @override
  State<AudioPlayingPage> createState() => _AudioPlayingPageState();
}

class _AudioPlayingPageState extends State<AudioPlayingPage>
    with TickerProviderStateMixin {
  AudioPlayer player = AudioPlayer();
  AppColors appColors = AppColors();
  MusicFuncs musicFuncs = MusicFuncs();

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

  playSong()
  {
    print("music on");
    player.play();
    setState(() {
      _controller.repeat();
      isPlaying = true;
      position = player.position;
    });
  }

  stopSong(){
    player.pause();
    setState(() {
      isPlaying = false;
      _controller.stop();
      position = player.position;
    });
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
      backgroundColor: appColors.darkPurple,
      body: Visibility(
        visible: isLoaded,
        replacement: Center(child: const CircularProgressIndicator()),
        child: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              // User swiped Left
              print("down");
              Navigator.pop(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
                color: appColors.lightPurple),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RecordWidget(
                    controller: _controller,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SongNameText(widget.item.displayNameWOExt,true),
                        SongNameText(widget.item.artist.toString(), false),
                      ],
                    ),
                  ),
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      await player.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(position)),
                      Text(formatTime(duration)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        child: IconButton(
                          icon: Icon(
                              Icons.skip_previous_outlined),
                          iconSize: 50,
                          onPressed: () async {
                            int itemPosition = widget.songs!.indexOf(widget.item);
                            int newItemPosition = 0;
                            itemPosition==0? newItemPosition = widget.songs!.length-1:newItemPosition = itemPosition-1;
                            Navigator.pop(context);
                            musicFuncs.chooseMusic(context, widget.songs!.elementAt(newItemPosition), widget.songs);

                          },
                        ),
                      ),
                      CircleAvatar(
                        radius: 35,
                        child: IconButton(
                          icon: Icon(
                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_outlined),
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
                      CircleAvatar(
                        radius: 35,
                        child: IconButton(
                          icon: Icon(
                              Icons.skip_next_outlined),
                          iconSize: 50,
                          onPressed: () async {
                            int itemPosition = widget.songs!.indexOf(widget.item);
                            int newItemPosition = 0;
                            itemPosition==widget.songs!.length? newItemPosition = 0:newItemPosition = itemPosition+1;
                            Navigator.pop(context);
                            musicFuncs.chooseMusic(context, widget.songs!.elementAt(newItemPosition), widget.songs);
                          },
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
