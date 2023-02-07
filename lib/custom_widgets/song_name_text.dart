import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SongNameText extends StatelessWidget {
  final String text;
  final bool isSong;
  const SongNameText(this.text,this.isSong, {super.key} );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(text,
        style: TextStyle(color: Colors.black,
            fontWeight: isSong?FontWeight.bold:FontWeight.w300,
            fontSize: 2.h),
      textAlign: TextAlign.center,),
    );
  }
}
