import 'package:weight_track_app/models/exercise.dart';

class ExerciseLogState {
  // Todo add init call setting index to 0 for page load
  int _currentDay;
  int _selectedIndex;
  Exercise _selectedExercise;

  ExerciseLogState._();

  factory ExerciseLogState.initial(int idOfDay) {
    return ExerciseLogState._()
      .._selectedIndex = 0
      .._currentDay = idOfDay;
  }

  set selectedIndex(int value) {
    _selectedIndex = value;
  }

  set selectedExercise(Exercise value) {
    _selectedExercise = value;
  }
}