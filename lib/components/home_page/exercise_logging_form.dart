import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/components/home_page/exercise_log_cubit.dart';
import 'package:weight_track_app/components/home_page/exercise_logging_form_field.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';
import 'package:weight_track_app/models/exercise_instance.dart';

import 'exercise_log_state.dart';

// TODO: fix error, when attempting to add to empty day

class ExerciseLoggingForm extends StatefulWidget {
  ExerciseLoggingForm();

  @override
  _ExerciseLoggingFormState createState() =>
      _ExerciseLoggingFormState();
}

class _ExerciseLoggingFormState extends State<ExerciseLoggingForm> {
  final _formKey = GlobalKey<FormState>();

  _ExerciseLoggingFormState();

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(color: Color(0xffBEBEBE), fontSize: 18.0),
                  ),
                  // TODO add check to default to going with a future builder and getting the text yourself from Database for first build
                  BlocBuilder<ExerciseLogCubit, ExerciseLogState>(
                    builder: (BuildContext context, ExerciseLogState titleState) {
                      return Text(
                        "Enter your last set of " + titleState.selectedExercise.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Raleway',
                            fontSize: 24.0),
                      );
                    },
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  ExerciseLoggingFormField(
                      loggingOnSaveWeights, 'Weight', 205),
                  SizedBox(
                    height: 17,
                  ),
                  ExerciseLoggingFormField(
                      loggingOnSaveReps, 'Rep Count', 285),
                  SizedBox(
                    height: 17,
                  ),
                  // TODO default to one set
                  ExerciseLoggingFormField(
                    loggingOnSaveSets, 'Set Count', 335, isLastField: true, finalizeData: finalizeData,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
      ),
    );
  }

  double _tmpWeight;
  int _tmpReps;
  int _tmpSets;

  String loggingOnSaveWeights(String s) {
    _tmpWeight = double.parse(s);
    return null;
  }

  String loggingOnSaveReps(String s) {
    _tmpReps = double.parse(s).round();
    return null;
  }

  String loggingOnSaveSets(String s) {
    _tmpSets = double.parse(s).round();
    return null;
  }

  void finalizeData() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _formKey.currentState.reset();

      ExerciseLogCubit cubit = BlocProvider.of<ExerciseLogCubit>(context);

      for (int i = 0; i < _tmpSets; i++) {
        DatabaseDataFiltered.addExerciseInstance(
            ExerciseInstance(reps: _tmpReps, weight: _tmpWeight),
            cubit.state.selectedExercise.id);
      }
    }
  }
}
