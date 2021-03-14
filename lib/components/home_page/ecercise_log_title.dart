import 'package:flutter/material.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';

class ExerciseLogTitle extends StatelessWidget {
  final int _idOfDay;
  ExerciseLogTitle(this._idOfDay);

  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Color(0xffA9D587), Color(0xff51C2A4)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Padding(
      padding: EdgeInsets.all(29.0),
      child: FutureBuilder(
        future: DatabaseDataFiltered.getNameOfDay(_idOfDay),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          String dayName;
          if (snapshot.data == null)
            dayName = "Day";
          else
            dayName = snapshot.data;
          return Text(
            dayName + "\nExercises",
            style: TextStyle(
              foreground: Paint()..shader = linearGradient,
              fontSize: 48.0,
              fontFamily: 'Raleway'
            ),
          );
        },
      ),
    );
  }
}
