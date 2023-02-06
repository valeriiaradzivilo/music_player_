import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordWidget extends StatefulWidget {
  const RecordWidget({super.key, required this.controller});

  final AnimationController controller;
  @override
  State<RecordWidget> createState() => _RecordWidgetState();
}

class _RecordWidgetState extends State<RecordWidget> with TickerProviderStateMixin{

  late final Animation<double> _animation = CurvedAnimation(
    parent: widget.controller,
    curve: Curves.linear,
  );
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
     super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return RotationTransition(
      turns: _animation,
      child: Container(
        width: 200,
        height: 205,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
            color: Color.fromRGBO(31, 31, 31, 1.0)),
        child: Container(

          decoration: BoxDecoration(
              border: Border.all(color: Colors.black,
              width: 50,),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(31, 31, 31, 1.0),
                width: 10,),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black,
                  width: 50,),
                borderRadius: BorderRadius.circular(100),
              ),
            ),),),

      ),
    );
  }
}
