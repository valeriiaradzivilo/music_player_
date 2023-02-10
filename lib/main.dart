import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_/pages/songs_list_page.dart';
import 'package:sizer/sizer.dart';


Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Music player',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: const Color.fromRGBO(135, 101, 194, 1.0),
        ),
        home: const SongsListPage(songModelItem: null, player: null, songs: null,),
      );
    });
  }
}

