import 'package:weight_track_app/models/exercise.dart';

class SettingsExerciseEditSelectionManager {
  static bool _isInSelectionMode = false;
  static List<Exercise> selectedExercises = [];
  static List<Function> _selectedListeners = [];
  static Function _lastOpenedAddingDialogue;
  static Function _fabListener;

  static bool isInSelectionMode() {
    return _isInSelectionMode;
  }

  static void putInSelectionMode() {
    _isInSelectionMode = true;
    try{
      _fabListener();
    }catch (e){}

  }

  static void addFabListener(Function listener){
    _fabListener = listener;
  }

  static void exitSelectionMode() {
    _isInSelectionMode = false;
    try{
      _fabListener();
    }catch (e){}
    clearSelection();
  }

  static bool isSelected(Exercise exercise) {
    return selectedExercises.contains(exercise);
  }

  static void addSelected(Exercise exercise, Function listener) {
    if (!selectedExercises.contains(exercise)) {
      selectedExercises.add(exercise);
      _selectedListeners.add(listener);
    }
  }

  static void removeSelected(Exercise exercise) {
    if (selectedExercises.contains(exercise)) selectedExercises.remove(exercise);
  }

  static void clearSelection() {
    selectedExercises = [];
    for (Function f in _selectedListeners)
      try {
        f();
      } catch (exception) {
      print("exception");
      }
    _selectedListeners = [];
  }

  static void setLastAddingDialogue(Function listener) {
    _lastOpenedAddingDialogue = listener;
  }

  static void closeLastAddingDialogue() {
    if (_lastOpenedAddingDialogue != null) {
      try {
        _lastOpenedAddingDialogue();
      } catch (Exception) {}
    }
  }

  static List<Exercise> getSelectedExercises(){
    return selectedExercises;
  }
}
