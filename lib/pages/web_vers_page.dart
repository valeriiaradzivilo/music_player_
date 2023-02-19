import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool loadedSong = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                              loadedSong = true;
                              isPlaying = true;

                            });




                          });
                        }
                      });
                    },
                    icon: Icon(Icons.upload_outlined)),

                loadedSong? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.deepPurple,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text("Your song is on"),
                        IconButton(onPressed: (){
                          isPlaying?audioElement.pause():audioElement.play();
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        }, icon: isPlaying?Icon(Icons.pause):Icon(Icons.play_arrow_outlined) )
                      ],
                    ),
                  ),
                ):SizedBox(),



              ]),
        ),
      ),
    );
  }
}
