import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_track_app/components/home_page/exercise_logging_form_field.dart';
import 'package:weight_track_app/components/home_page/exercise_selection_manager.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';
import 'package:weight_track_app/models/exercise_instance.dart';

// TODO: fix error, when attempting to add to empty day

class ExerciseLoggingForm extends StatefulWidget {
  final int _idOfDay;
  ExerciseLoggingForm(this._idOfDay);

  @override
  _ExerciseLoggingFormState createState() =>
      _ExerciseLoggingFormState(_idOfDay);
}

class _ExerciseLoggingFormState extends State<ExerciseLoggingForm> {
  final _formKey = GlobalKey<FormState>();
  final int _idOfDay;
  double _tmpWeight;
  int _tmpReps;
  int _tmpSets;

  _ExerciseLoggingFormState(this._idOfDay);

  @override
  Widget build(BuildContext context) {
    ExerciseSelectionManager.addListener(() => setState(() {}), _idOfDay);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xffEFFDF1), borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Logging",
                  style: TextStyle(
                      color: Color(0xffBEBEBE),
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontSize: 18.0),
                ),
                // TODO add check to default to going with a future builder and getting the text yourself from Database for first build
                Text(
                  "Enter your last set of " +
                      ExerciseSelectionManager.getSelectedExercise(_idOfDay)
                          .name,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: GoogleFonts.raleway().fontFamily,
                      fontSize: 24.0),
                ),
                SizedBox(
                  height: 35,
                ),
                ExerciseLoggingFormField(
                    loggingOnSaveWeights, loggingValidate, 'Weight', 205),
                SizedBox(
                  height: 17,
                ),
                ExerciseLoggingFormField(
                    loggingOnSaveReps, loggingValidate, 'Rep Count', 285),
                SizedBox(
                  height: 17,
                ),
                // TODO default to one set
                ExerciseLoggingFormField(
                  loggingOnSaveSets,
                  loggingValidate,
                  'Set Count',
                  335,
                  isLastField: true,
                  gvnOnDone: loggingOnDone,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loggingOnDone() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _formKey.currentState.reset();
      for (int i = 0; i < _tmpSets; i++) {
        DatabaseDataFiltered.addExerciseInstance(
            ExerciseInstance(reps: _tmpReps, weight: _tmpWeight),
            ExerciseSelectionManager.getSelectedExercise(_idOfDay).id);
      }
    }
  }

  String loggingOnSaveWeights(String s) {
    _tmpWeight = double.parse(s);
    return null;
  }

  String loggingOnSaveReps(String s) {
    _tmpReps = int.parse(s);
    return null;
  }

  String loggingOnSaveSets(String s) {
    _tmpSets = int.parse(s);
    return null;
  }

  String loggingValidate(String s) {
    try {
      double.parse(s);
    } catch (FormatException) {
      return "Please enter a valid number";
    }

    return null;
  }
}
