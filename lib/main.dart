import 'package:flutter/material.dart';
import 'package:music_player_/pages/songs_list_page.dart';
import 'package:sizer/sizer.dart';


void main() {
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
          primaryColor: Color.fromRGBO(135, 101, 194, 1.0),
        ),
        home: const SongsListPage(isPlaying: null,songModelItem: null, player: null,),
      );
    });
  }
}

