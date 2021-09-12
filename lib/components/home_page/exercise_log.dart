import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weight_track_app/components/home_page/ecercise_log_title.dart';
import 'package:weight_track_app/components/home_page/exercise_list.dart';
import 'package:weight_track_app/components/shared/info_text.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';

import 'exercise_logging_form.dart';

class ExerciseLogPage extends StatelessWidget {
  final int _idOfDay;

  ExerciseLogPage(this._idOfDay);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseDataFiltered.dayContainsExercises(_idOfDay),
      builder: (BuildContext buildContext, AsyncSnapshot<bool> doesContainSnapshot) {
        if (doesContainSnapshot.data == null) {
          return Container();
        } else if (!doesContainSnapshot.data) {
          // catch day not having exercises
          return SafeArea(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExerciseLogTitle(_idOfDay),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: InfoText('No exercises found for this day, please add some in the settings'),
              ),
            ],
          ));
        }
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExerciseLogTitle(_idOfDay),
                ExerciseLoggingForm(_idOfDay),
                SizedBox(
                  height: 20.0,
                ),
                ExerciseListWidget(_idOfDay),
                SizedBox(
                  height: 100.0,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

