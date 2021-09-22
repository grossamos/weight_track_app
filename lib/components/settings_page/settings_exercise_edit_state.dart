import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class SettingsEditState {
  final bool isEditing;
  final bool isAddingExercise;

  SettingsEditState.initial() : isEditing = false, isAddingExercise = false;
  SettingsEditState(this.isEditing, this.isAddingExercise);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsEditState
          && runtimeType == other.runtimeType
          && isEditing == other.isEditing
          && isAddingExercise == other.isAddingExercise;

  @override
  int get hashCode => isEditing.hashCode ^ isAddingExercise.hashCode;
}

class SettingsEditCubit extends Cubit<SettingsEditState> {
  SettingsEditCubit() : super(SettingsEditState.initial());
  
  void flipEditMode() {
    emit(SettingsEditState(!state.isEditing, false));
  }

  void enterNewAddingMode() {
    emit(SettingsEditState(false, true));
  }
}