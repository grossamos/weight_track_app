import 'package:flutter/material.dart';
import 'package:weight_track_app/components/home_page/home_helper.dart';
import 'package:weight_track_app/components/shared/info_text.dart';
import 'package:weight_track_app/components/shared/title_text.dart';
import 'package:weight_track_app/components/shared/widget_util.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';

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
              child: TitleText('What are you training today?'),
            ),
            FutureBuilder(
              future: DatabaseDataUnfiltered.getEmptyDaysOfSplit(),
              builder: (BuildContext context, AsyncSnapshot<List<DayOfSplit>> snapshot){
                if (snapshot.data == null)
                  return Container();
                else if (snapshot.data.isEmpty)
                  return InfoText('Much empty.\nPlease add your split in the settings.');
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
      return Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Color.fromRGBO(0xF3, 0xF3, 0xF3, 1),
        child: ListTile(
          leading: dayIconShader,
          title: Text(
            days[index].name,
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'Raleway'
            ),
          ),
          subtitle: FutureBuilder(
            future: DatabaseDataFiltered.getQuickInfoForDay(days[index].id),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
              if (snapshot.data == null)
                return Text(loadingText, style: subtitleTextStyle);
              else
                return Text(snapshot.data, style: subtitleTextStyle);
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