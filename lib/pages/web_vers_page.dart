import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_/pages/audio_playing_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:html' as html;

import '../custom_widgets/song_name_text.dart';

class WebPageVers extends StatefulWidget {
  const WebPageVers({Key? key}) : super(key: key);

  @override
  State<WebPageVers> createState() => _WebPageVersState();
}

class _WebPageVersState extends State<WebPageVers> {
  html.AudioElement audioElement = html.AudioElement();
  late Uint8List fileContents;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO: implement playing uploaded song
                const Text(
                  "Choose what to listen to",
                ),
                IconButton(
                    onPressed: () async {
                      html.FileUploadInputElement input =
                          html.FileUploadInputElement();
                      input.click();

                      input.onChange.listen((e) {
                        final files = input.files;
                        if (files?.length != 0) {
                          final file = files![0];
                          final reader = html.FileReader();
                          reader.readAsArrayBuffer(file);

                          reader.onLoadEnd.listen((e) async {
                            setState(() {
                              fileContents = reader.result as Uint8List;
                              audioElement.src =
                                  html.Url.createObjectUrlFromBlob(file);
                              audioElement.play();

                            });
                            final OnAudioQuery audioQuery = OnAudioQuery();
                            List<SongModel> songs = await audioQuery.querySongs(
                              sortType: SongSortType.TITLE, // This line sets the sort order
                            );
                            SongModel item = songs.elementAt(0);

                            const AudioPlayingPage();



                          });
                        }
                      });
                    },
                    icon: Icon(Icons.upload_outlined))
              ]),
        ),
      ),
    );
  }
}
