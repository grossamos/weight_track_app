import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_track_app/components/analytics_page/split_day_graph.dart';
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Analytics",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color.fromRGBO(0xBF, 0xBF, 0xBF, 1),
                                fontFamily: GoogleFonts.raleway().fontFamily,
                                fontSize: 48
                            ),
                          ),
                        ),
                        Column(
                          children:
                              List.generate(daysSnapshot.data.length, (index) => GraphForSplitDay(daysSnapshot.data[index])),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
