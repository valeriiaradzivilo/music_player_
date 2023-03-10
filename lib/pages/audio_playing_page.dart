import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_/classes/app_colors.dart';
import 'package:music_player_/classes/music_funcs.dart';
import 'package:music_player_/custom_widgets/play_button.dart';
import 'package:music_player_/custom_widgets/record.dart';
import 'package:music_player_/custom_widgets/skip_button.dart';
import 'package:music_player_/custom_widgets/song_name_text.dart';
import 'package:music_player_/pages/songs_list_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sizer/sizer.dart';

class AudioPlayingPage extends StatefulWidget {
  const AudioPlayingPage({
    super.key,
    required this.item,
    required this.songs,
    required this.oldPlayer,
  });
  final SongModel item;
  final List<SongModel>? songs;
  final AudioPlayer? oldPlayer;

  @override
  State<AudioPlayingPage> createState() => _AudioPlayingPageState();
}

class _AudioPlayingPageState extends State<AudioPlayingPage>
    with TickerProviderStateMixin {
  late AudioPlayer player = AudioPlayer();
  AppColors appColors = AppColors();
  late MusicFuncs musicFuncs;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isLoaded = false;

  setSong() async {
    try {
        player = widget.oldPlayer!;
        setState(() {
          isPlaying = true;
          duration = Duration(milliseconds: widget.item.duration!);
          isLoaded = true;        });

    } on Exception {
      log("Error parsing song");
      isLoaded = false;
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setSong();
    _controller.addListener(() {
      setState(() {
        position = player.position;
      });
    });

    setState(() {
      musicFuncs = MusicFuncs(context, widget.songs, widget.item, player);
    });
    super.initState();
  }

  playSong() {
    musicFuncs.playSong(player);
    setState(() {
      _controller.repeat();
      isPlaying = true;
      position = player.position;
    });
  }

  stopSong() {
    musicFuncs.pauseSong(player);
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
        replacement: const Center(child: CircularProgressIndicator()),
        child: GestureDetector(
          onVerticalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! > 0) {
              // User swiped down

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SongsListPage(
                          songModelItem: widget.item,
                          player: player,
                          songs: widget.songs,
                        )),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
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
                        SongNameText(widget.item.displayNameWOExt, true),
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
                      skipButton(false, musicFuncs.playNextSongNChooseMusic, musicFuncs.playPreviousSongNChooseMusic,5.h),
                      playButton(isPlaying, playSong, stopSong,5.h),
                      skipButton(true, musicFuncs.playNextSongNChooseMusic, musicFuncs.playPreviousSongNChooseMusic,5.h),
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
