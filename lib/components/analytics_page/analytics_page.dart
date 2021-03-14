import 'package:flutter/material.dart';
import 'package:weight_track_app/components/analytics_page/split_day_graph.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
              future: DatabaseDataUnfiltered.getEmptyDaysOfSplit(),
              builder: (BuildContext dayContext,
                  AsyncSnapshot<List<DayOfSplit>> daysSnapshot) {
                if (daysSnapshot.data == null){
                  return Text('loading...');
                }
                return SingleChildScrollView(
                  child: Column(
                    children:
                        List.generate(daysSnapshot.data.length, (index) => GraphForSplitDay(daysSnapshot.data[index])),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
