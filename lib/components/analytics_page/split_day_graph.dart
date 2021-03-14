import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';
import 'package:weight_track_app/models/exercise.dart';

class GraphForSplitDay extends StatefulWidget {
  final DayOfSplit _dayOfSplit;

  GraphForSplitDay(this._dayOfSplit);

  @override
  _GraphForSplitDayState createState() => _GraphForSplitDayState(_dayOfSplit);
}

class _GraphForSplitDayState extends State<GraphForSplitDay> {
  final DayOfSplit _dayOfSplit;

  _GraphForSplitDayState(this._dayOfSplit);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseDataFiltered.getChartDataOfDay(_dayOfSplit.id),
      builder: (BuildContext context, AsyncSnapshot<LineChartBarData> dataSnapshot){
        if (dataSnapshot.data == null)
          return Text("Loading: " + _dayOfSplit.name);
        else
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Container(
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  lineBarsData: [dataSnapshot.data],
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: false,
                  ),
                  gridData: FlGridData(
                    show: false
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTextStyles: (value) => const TextStyle(
                    color: Color(0xff72719b),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    ),
                    margin: 10,
                  ),
                    leftTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                    border: const Border(
                      bottom: BorderSide(
                        color: Color(0xff4e4965),
                        width: 4,
                      ),
                      left: BorderSide(
                        color: Colors.transparent,
                      ),
                      right: BorderSide(
                        color: Colors.transparent,
                      ),
                      top: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  )
                ),
              ),
            ));
      },
    );
  }
}

Future<LineChartBarData> getChartDataOfDay(DayOfSplit dayOfSplit) async {
  List<Exercise> exercisesOfDay = await DatabaseDataUnfiltered.getExercisesOfDay(dayOfSplit.id);
  return LineChartBarData(
      spots: List.generate(exercisesOfDay.length, (index) => null)
  );
}