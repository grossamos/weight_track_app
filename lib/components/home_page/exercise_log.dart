import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weight_track_app/components/home_page/ecercise_log_title.dart';
import 'package:weight_track_app/components/home_page/exercise_list.dart';

import 'exercise_logging_form.dart';

class ExerciseLogPage extends StatelessWidget {
  final int _idOfDay;

  ExerciseLogPage(this._idOfDay);

  @override
  Widget build(BuildContext context) {
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
            ExerciseListWidget(_idOfDay)
          ],
        ),
      ),
    );
  }
}

