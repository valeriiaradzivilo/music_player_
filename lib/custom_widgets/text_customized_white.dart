import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TextZip extends StatelessWidget {
  const TextZip(this.text,{Key? key}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(text,
      style: TextStyle(color: Colors.white,
      fontSize: 2.h),
      overflow: TextOverflow.ellipsis,),
    );
  }
}
