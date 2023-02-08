import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_/classes/app_colors.dart';
import 'package:music_player_/classes/music_funcs.dart';
import 'package:music_player_/custom_widgets/play_button.dart';
import 'package:music_player_/custom_widgets/text_customized_white.dart';
import 'package:on_audio_query/on_audio_query.dart';
class SmallSongLine extends StatefulWidget {
  const SmallSongLine({Key? key, required this.item, required this.player, required this.songs}) : super(key: key);
  final SongModel? item;
  final AudioPlayer? player;
  final List<SongModel>? songs;
  @override
  State<SmallSongLine> createState() => _SmallSongLineState();
}

class _SmallSongLineState extends State<SmallSongLine> with TickerProviderStateMixin{
  MusicFuncs musicFuncs = MusicFuncs();
  late bool isPlaying = widget.player!.playing;
  AppColors appColors = AppColors();
  late Duration position;




  @override
  void initState() {
    isPlaying = widget.player!.playing;
      setState(() {
        position = widget.player!.position;
      });

    super.initState();
  }

  playSong(){
    setState(() {
      isPlaying = true;
    });
    musicFuncs.playSong(widget.player!);
}

  pauseSong()
  {
    setState(() {
      isPlaying = false;
    });
    musicFuncs.pauseSong(widget.player!);
  }


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        position = widget.player!.position;
        musicFuncs.chooseMusic(context, widget.item!, widget.songs,widget.player);
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
        color: appColors.lightPurple),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            playButton(isPlaying, playSong,
                pauseSong),
                Expanded(
                    child: TextZip("${widget.item!.displayNameWOExt}\n${widget.item!.artist!}")),
          ]),
        ),
      ),
    );
  }
}

