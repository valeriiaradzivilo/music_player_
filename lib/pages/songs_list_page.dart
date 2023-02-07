
import 'package:flutter/material.dart';
import 'package:music_player_/classes/music_funcs.dart';

import 'package:music_player_/pages/audio_playing_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../classes/app_colors.dart';
import '../classes/bottom_choice.dart';
import '../custom_widgets/text_customized_white.dart';


class SongsListPage extends StatefulWidget {
  const SongsListPage({super.key});

  @override
  State<SongsListPage> createState() => _SongsListPageState();
}

class _SongsListPageState extends State<SongsListPage> {
  AppColors appColors = AppColors();
  MusicFuncs musicFuncs = MusicFuncs();
  final _audioQuery = OnAudioQuery();
  bool musicIsLoaded = false;
  List<BottomChoice> bottomChoices = [
    const BottomChoice(
        title: "Home", icon: Icons.home_filled, onTapFunction: null)
  ];



  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
    setState(() {
      musicIsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.purple,
      appBar: null,
      bottomNavigationBar: BottomAppBar(
        color: appColors.lightPurple,
        child: IconTheme(
          data: IconThemeData(color: Colors.black),
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
        builder: (context, item) {
          if (item.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(child: TextZip("No songs found"));
          }
          return CustomScrollView(slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(top:5.h,bottom: 5.h),
              sliver: SliverAppBar(
                stretch: true,
                expandedHeight: 10.h,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  centerTitle: true,

                  title: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Zip Player",
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 5.h,),),
                  ),

                ),
                backgroundColor: appColors.purple,
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Hero(
                      tag: 'music_$index',
                      child: Material(
                        color: Color.fromRGBO(0, 0, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.play_arrow_outlined),
                            ),
                            title: TextZip(item.data![index].displayNameWOExt),
                            subtitle:
                            TextZip(item.data![index].artist.toString()),
                            tileColor: appColors.darkPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onTap: () => musicFuncs.chooseMusic(context,item.data![index],
                                item.data),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: item.data?.length,
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

