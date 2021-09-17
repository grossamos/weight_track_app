import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/components/home_page/exercise_log_state.dart';
import 'package:weight_track_app/models/exercise.dart';

class ExerciseLogCubit extends Cubit<ExerciseLogState> {
  ExerciseLogCubit(int idOfDay) : super(ExerciseLogState.initial(idOfDay));

  void changeSelectedExercise(int index, Exercise exercise) {
    emit(ExerciseLogState(state.currentDay, index, exercise));
  }
}