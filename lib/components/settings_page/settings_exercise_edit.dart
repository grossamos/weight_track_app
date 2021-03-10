import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_track_app/components/settings_page/settings_adding_dialogue.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_chip.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_fab.dart';
import 'package:weight_track_app/components/settings_page/settings_exercise_edit_selection_manager.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';
import 'package:weight_track_app/models/exercise.dart';
import 'package:weight_track_app/navigation/main_route_constants.dart';

class SettingsExerciseEdit extends StatefulWidget {
  @override
  _SettingsExerciseEditState createState() => _SettingsExerciseEditState();
}

class _SettingsExerciseEditState extends State<SettingsExerciseEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SettingsEditFAB(() => SettingsExerciseEditSelectionManager.isInSelectionMode(),
          () {
            if (!SettingsExerciseEditSelectionManager.isInSelectionMode())
              SettingsExerciseEditSelectionManager.putInSelectionMode();
            else {
              _showDeleteDialogue(context);
            }
          }, (Function listener) => SettingsExerciseEditSelectionManager.addFabListener(listener)),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTitle(
              "Exercises",
              "Edit your Exercises",
              onClose: () {
                SettingsExerciseEditSelectionManager.exitSelectionMode();
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 100),
              child: FutureBuilder(
                future: DatabaseDataUnfiltered.getEmptyDaysOfSplit(),
                builder: (BuildContext daysContext,
                    AsyncSnapshot<List<DayOfSplit>> daysSnapshot) {
                  if (daysSnapshot.data == null) return Container();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        daysSnapshot.data.length,
                        (indexOfDay) => SettingsExerciseOfDayEdit(
                            daysSnapshot.data[indexOfDay])),
                  );
                },
              ),
            )
          ],
        )),
      ),
    );
  }

  Future<void> _showDeleteDialogue(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Selection"),
            content: Text(
                "Are you sure you wish to delete all selected Exercises and their data?\nThis action cannot be undone."),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  SettingsExerciseEditSelectionManager.exitSelectionMode();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Delete"),
                onPressed: () {
                  mainNavigatorKey.currentState.pop();
                  for (Exercise exercise in SettingsExerciseEditSelectionManager
                      .getSelectedExercises()) {
                    DatabaseDataUnfiltered.deleteExercise(exercise);
                  }
                  SettingsExerciseEditSelectionManager.exitSelectionMode();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
  
}

class SettingsExerciseOfDayEdit extends StatefulWidget {
  final DayOfSplit _day;

  SettingsExerciseOfDayEdit(
    this._day,
  );

  @override
  _SettingsExerciseOfDayEditState createState() =>
      _SettingsExerciseOfDayEditState(_day);
}

class _SettingsExerciseOfDayEditState extends State<SettingsExerciseOfDayEdit> {
  final DayOfSplit _day;
  bool _isAddingAnExercise = false;
  _SettingsExerciseOfDayEditState(this._day);

  void _enterAddingDialogue() {
    setState(() {
      if (!_isAddingAnExercise) {
        SettingsExerciseEditSelectionManager.closeLastAddingDialogue();
        _isAddingAnExercise = true;
      } else {
        _isAddingAnExercise = false;
      }
    });
    SettingsExerciseEditSelectionManager.setLastAddingDialogue(
        _exitAddingDialogue);
  }

  void _exitAddingDialogue() {
    setState(() {
      _isAddingAnExercise = false;
    });
  }

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
                  fontFamily: GoogleFonts.roboto().fontFamily),
            ),
            IconButton(
                icon: Icon(
                  Icons.add,
                  color: Color(0xff929292),
                ),
                onPressed: _enterAddingDialogue)
          ],
        ),
      ),
      FutureBuilder(
        future: DatabaseDataUnfiltered.getExercisesOfDay(_day.id),
        builder: (BuildContext exerciseContext,
            AsyncSnapshot<List<Exercise>> exerciseSnapshot) {
          if (exerciseSnapshot.data == null) return Container();
          return Container(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(
                  exerciseSnapshot.data.length,
                  (int exerciseIndex) => SettingsEditChip(
                      exerciseSnapshot.data[exerciseIndex].name,
                      () {
                        SettingsExerciseEditSelectionManager
                            .putInSelectionMode();
                      },
                      () {},
                      () => SettingsExerciseEditSelectionManager.isSelected(
                          exerciseSnapshot.data[exerciseIndex]),
                      (Function listener) {
                        if (!SettingsExerciseEditSelectionManager.isSelected(
                            exerciseSnapshot.data[exerciseIndex]))
                          SettingsExerciseEditSelectionManager.addSelected(
                              exerciseSnapshot.data[exerciseIndex],
                              listener);
                        else
                          SettingsExerciseEditSelectionManager.removeSelected(
                              exerciseSnapshot.data[exerciseIndex]);
                      },
                      () => SettingsExerciseEditSelectionManager
                          .isInSelectionMode())),
            ),
          );
        },
      ),
      // TODO fix exercises throwing errors when being used after added
      _isAddingAnExercise
          ? SettingsAddingDialogue('Enter new Exercise',(String newExerciseName) {
              DatabaseDataUnfiltered.addExercise(_day.id,
                  Exercise(name: newExerciseName, exerciseSessions: []));
              _exitAddingDialogue();
              Fluttertoast.showToast(msg: "Saving...");
            })
          : Container(),
    ]);
  }
}