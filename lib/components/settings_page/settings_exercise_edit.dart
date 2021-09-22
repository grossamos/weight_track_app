import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_chip.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_fab.dart';
import 'package:weight_track_app/components/settings_page/settings_exercise_edit_state.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';
import 'package:weight_track_app/models/exercise.dart';

class SettingsExerciseEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => new SettingsEditCubit(),
      child: Scaffold(
        floatingActionButton: SettingsEditFAB(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsTitle('Exercises', 'Edit your Exercises'),
                Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 100),
                    child: FutureBuilder(
                        future: DatabaseDataUnfiltered.getEmptyDaysOfSplit(),
                        builder: (BuildContext daysContext, AsyncSnapshot<List<DayOfSplit>> daysSnapshot) {
                          if (daysSnapshot.data == null) return Container();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(daysSnapshot.data.length,
                                    (indexOfDay) => SettingsExerciseOfDayEdit(daysSnapshot.data[indexOfDay])),
                          );
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsExerciseOfDayEdit extends StatelessWidget {
  final DayOfSplit _day;

  SettingsExerciseOfDayEdit(this._day);


  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          children: [
            Text(
              _day.name,
              style: TextStyle(
                color: Color(0xff929292),
                fontSize: 24,
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Color(0xff929292),
                ),
                onPressed: BlocProvider
                    .of<SettingsEditCubit>(context)
                    .flipEditMode)
          ],
        ),
      ),
      FutureBuilder(
          future: DatabaseDataUnfiltered.getExercisesOfDay(_day.id),
          builder: (BuildContext exerciseContext, AsyncSnapshot<List<Exercise>> exerciseSnapshot) {
            if (exerciseSnapshot.data == null) return Container();
            return BlocBuilder<SettingsEditCubit, SettingsEditState>(
              bloc: BlocProvider.of<SettingsEditCubit>(context),
              builder: (BuildContext context, SettingsEditState state) {
                return Column(
                  children: List.generate(
                      exerciseSnapshot.data.length,
                          (int exerciseIndex) => SettingsExerciseEditChip(exerciseSnapshot.data[exerciseIndex].name, state.isEditing)),
                );
              },
            );
          })
    ]);
    //   ),
    //   _isAddingAnExercise
    //       ? SettingsAddingDialogue('Enter new Exercise', (String newExerciseName) {
    //           DatabaseDataUnfiltered.addExercise(_day.id, Exercise(name: newExerciseName, exerciseSessions: []));
    //           _exitAddingDialogue();
    //           Fluttertoast.showToast(msg: "Saving...");
    //         })
    //       : Container(),
    // ]);
  }
}
