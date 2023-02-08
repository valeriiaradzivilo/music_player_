import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Padding skipButton(bool isNext, goForward, goBackward, double size) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
      radius: size,
      child: IconButton(
        icon: Icon(isNext ? Icons.skip_next_outlined : Icons.skip_previous_outlined),
        iconSize: size,
        onPressed: () async {
          if (isNext) {
              goForward();
          } else {
            goBackward();
          }
        },
      ),
    ),
  );
}
