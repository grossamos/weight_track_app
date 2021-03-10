import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';
import 'dart:ui' as ui;

import 'package:weight_track_app/navigation/main_route_constants.dart';

class ExerciseDayOfSplitPage extends StatefulWidget {
  @override
  _ExerciseDayOfSplitPageState createState() => _ExerciseDayOfSplitPageState();
}

class _ExerciseDayOfSplitPageState extends State<ExerciseDayOfSplitPage> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 110.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                "What are you training today?",
                style: TextStyle(
                    color: Color.fromRGBO(0xBF, 0xBF, 0xBF, 1),
                    fontFamily: GoogleFonts.raleway().fontFamily,
                    fontSize: 48
                ),
              ),
            ),
            FutureBuilder(
              future: DatabaseDataUnfiltered.getEmptyDaysOfSplit(),
              builder: (BuildContext context, AsyncSnapshot<List<DayOfSplit>> snapshot){
                if (snapshot.data == null){
                  return Text('loading');
                }
                return Container(
                  child: Column(
                    children: listOfDayTiles(snapshot.data),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> listOfDayTiles(List<DayOfSplit> days){
    return List.generate(days.length, (index) {
      Widget tileIcon =  ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds){
            return ui.Gradient.linear(
              Offset(0, 20),
              Offset(20, 0),
              [
                Color.fromRGBO(0xBE, 0xE8, 0x97, 1),
                Color.fromRGBO(0x05, 0xCD, 0x87, 1)
              ],
            );
          },
          child: Icon(
            Icons.circle,
            size: 40,
          )
      );
      return Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Color.fromRGBO(0xF3, 0xF3, 0xF3, 1),
        child: ListTile(
          leading: tileIcon,
          title: Text(
            days[index].name,
            style: TextStyle(
                fontSize: 24,
                fontFamily: GoogleFonts.raleway().fontFamily
            ),
          ),
          subtitle: FutureBuilder(
            future: DatabaseDataFiltered.getQuickInfoForDay(days[index].id),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
              TextStyle textStyle = TextStyle(
                  fontSize: 17,
                  fontFamily: GoogleFonts.roboto().fontFamily
              );
              if (snapshot.data == null)
                return Text('loading', style: textStyle);
              else
                return Text(snapshot.data, style: textStyle);
            },
          ),
          onTap: (){
            mainNavigatorKey.currentState.pushNamed('/home/exercise_overview', arguments: days[index].id);
          },
        ),
      );
    });
  }
}