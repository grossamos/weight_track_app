import 'package:flutter/cupertino.dart';
import 'package:weight_track_app/models/exercise.dart';

@immutable
class ExerciseLogState {
  final int _currentDay;
  final int selectedIndex;
  final Exercise selectedExercise;

  ExerciseLogState(this._currentDay, this.selectedIndex, this.selectedExercise);

  factory ExerciseLogState.initial(int idOfDay) {
    return ExerciseLogState(idOfDay, 0, Exercise(id: 0, name: 'Exercise'));
  }

  int get currentDay => _currentDay;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseLogState &&
          runtimeType == other.runtimeType &&
          _currentDay == other._currentDay &&
          selectedIndex == other.selectedIndex &&
          selectedExercise == other.selectedExercise;

  @override
  int get hashCode =>
      _currentDay.hashCode ^ selectedIndex.hashCode ^ selectedExercise.hashCode;
}