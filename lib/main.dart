import 'dart:io';

import 'package:flutter/material.dart';

import 'package:music_player_/pages/audio_playing_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import 'classes/bottom_choice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music player',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _audioQuery = new OnAudioQuery();
  bool musicIsLoaded = false;
  List<BottomChoice> bottomChoices = [
    const BottomChoice(
        title: "Home", icon: Icons.home_filled, onTapFunction: null)
  ];

  /// on list tile tap open chosen music file
  chooseMusic(SongModel item) {
    print("play music {$item.displayName}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioPlayingPage(item:item),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission()
  {
    Permission.storage.request();
    setState(() {
      musicIsLoaded = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: true,
      replacement: Center(child: CircularProgressIndicator()),
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(0, 0, 47, 1.0),
          appBar: null,
          bottomNavigationBar: BottomAppBar(
            color: const Color.fromRGBO(37, 0, 110, 1.0),
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < bottomChoices.length; i++)
                    IconButton(
                        onPressed: bottomChoices.elementAt(i).onTapFunction,
                        icon: Icon(bottomChoices.elementAt(i).icon))
                ],
              ),
            ),
          ),
          body: FutureBuilder<List<SongModel>>(
            future: _audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, item)
            {
              if(item.data  == null)
                {
                  return Center(child: CircularProgressIndicator(),);
                }
              if(item.data!.isEmpty){
                return Center(child: Text("No songs found"));
              }
              return ListView.builder(
                itemCount: item.data?.length,
                itemBuilder: (context, index) {
                  return Hero(
                    tag: 'music_$index',
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.play_arrow_outlined),
                          ),
                          title: Text(item.data![index].displayNameWOExt),
                          subtitle: Text(item.data![index].artist.toString()),
                          tileColor: Colors.deepPurple[800],
                          onTap: ()=>chooseMusic(item.data![index]),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
