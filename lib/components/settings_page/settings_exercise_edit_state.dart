import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';
import 'package:weight_track_app/models/exercise.dart';

@immutable
class SettingsEditState {
  final bool isEditing;
  final bool isAddingExercise;
  final int idOfDayBeingEdited;
  final int seed;

  SettingsEditState.initial() : isEditing = false, isAddingExercise = false, idOfDayBeingEdited = -1, seed = 0;
  SettingsEditState(this.isEditing, this.isAddingExercise, {this.idOfDayBeingEdited = -1, this.seed = 0});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsEditState
          && runtimeType == other.runtimeType
          && isEditing == other.isEditing
          && isAddingExercise == other.isAddingExercise
          && idOfDayBeingEdited == other.idOfDayBeingEdited
          && seed == other.seed;

  @override
  int get hashCode => isEditing.hashCode ^ isAddingExercise.hashCode ^ idOfDayBeingEdited ^ seed;
}

class SettingsAddStateSingleton {
  static String name;

  SettingsAddStateSingleton._private();

  static void saveStateExercise(int idOfDay) {
    if (name != ''){
      DatabaseDataUnfiltered.addExercise(idOfDay, new Exercise(name: SettingsAddStateSingleton.name));
      name = '';
    }
  }
  static void saveStateDay() {
    if (name != '') {
      DatabaseDataUnfiltered.addDayOfSplit(new DayOfSplit(name: name));
    }
  }
}

class SettingsEditCubit extends Cubit<SettingsEditState> {
  SettingsEditCubit() : super(SettingsEditState.initial());

  void changeSeed() {
    emit(SettingsEditState(state.isEditing, state.isAddingExercise, seed: state.seed + 1));
  }

  void flipEditMode() {
    emit(SettingsEditState(!state.isEditing, false));
  }

  void exitNewAddingMode() {
    if (state.idOfDayBeingEdited > 0)
      SettingsAddStateSingleton.saveStateExercise(state.idOfDayBeingEdited);
    else
      SettingsAddStateSingleton.saveStateDay();

    emit(SettingsEditState(false, false, idOfDayBeingEdited: -1));
  }

  void enterNewAddingMode(int idOfDay) {
    exitNewAddingMode();
    emit(SettingsEditState(false, true, idOfDayBeingEdited: idOfDay));
  }
}