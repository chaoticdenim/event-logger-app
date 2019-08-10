import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'moods.dart';

 class CustomButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final int id;
 
  CustomButton({@required this.onPressed, @required this.id});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).accentColor,
      child: new Text(
          MoodToName.getMoodEmoji(id),
          style: new TextStyle(
            fontSize: 20.0
          ),
        ),
      shape: const StadiumBorder(),
    );
  }


}