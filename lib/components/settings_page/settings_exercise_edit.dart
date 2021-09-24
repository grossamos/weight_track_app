import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_chip.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_fab.dart';
import 'package:weight_track_app/components/settings_page/settings_exercise_edit_state.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';
import 'package:weight_track_app/components/shared/info_text.dart';
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
                          if (daysSnapshot.data.isEmpty) return Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: InfoText('Please add a training split in order to add exercises.', noCenter: true,),
                          );
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
                onPressed: () {
                  BlocProvider.of<SettingsEditCubit>(context).enterNewAddingMode(_day.id);
                })
          ],
        ),
      ),
      BlocBuilder<SettingsEditCubit, SettingsEditState>(
        builder: (BuildContext context, SettingsEditState state) {
          return FutureBuilder(
              future: DatabaseDataUnfiltered.getExercisesOfDay(_day.id),
              builder: (BuildContext exerciseContext, AsyncSnapshot<List<Exercise>> exerciseSnapshot) {
                if (exerciseSnapshot.data == null) return Container();
                return Column(
                  children: List<SettingsEditChip>.generate(
                          exerciseSnapshot.data.length,
                          (int exerciseIndex) => SettingsExerciseEditChip(
                              context, exerciseSnapshot.data[exerciseIndex], state.isEditing)) +
                      (state.isAddingExercise && state.idOfDayBeingEdited == _day.id
                          ? [SettingsAddChip(context, true)]
                          : []),
                );
              });
        },
      )
    ]);
  }
}
