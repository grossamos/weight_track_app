import 'package:weight_track_app/models/exercise.dart';

class ExerciseSelectionManager{
  static Map<int, int> _selectedIndexes = {};
  static Map<int, Function> _lastSelectedUpdaters = {};
  static Map<int, Function> _updateListeners = {};
  static Map<int, List<Exercise>> _exercises = {};
  
  static void addListener(Function() listener, int idOfDay){
    _updateListeners.putIfAbsent(idOfDay, () => listener);
  }
  
  static void updateExercises(List<Exercise> exerciseList, int idOfDay){
    if (_exercises.containsKey(idOfDay))
      _exercises.update(idOfDay, (value) => exerciseList);
    else
      _exercises.putIfAbsent(idOfDay, () => exerciseList);
  }

  static void setLastSelectedUpdater(Function() updateLast, int idOfDay){
    _lastSelectedUpdaters[idOfDay] = updateLast;
  }

  static void callLastSelectedUpdater(int idOfDay){
    _lastSelectedUpdaters[idOfDay]();
  }

  static void updateListeners(int idOfDay){
    _updateListeners[idOfDay]();
  }

  static void updateSelectedIndexes(int selectedIndex, int idOfDay){
    if (_selectedIndexes.containsKey(idOfDay))
      _selectedIndexes.update(idOfDay, (value) => selectedIndex);
    else
      _selectedIndexes.putIfAbsent(idOfDay, () => selectedIndex);
  }

  static bool checkIfSelected(int index, int idOfDay){
    int selectedIndex = _selectedIndexes[idOfDay];
    if (selectedIndex == null)
      selectedIndex = 0;
    return selectedIndex == index;
  }
  
  static Exercise getSelectedExercise(int idOfDay){
    int selectedIndex = _selectedIndexes[idOfDay];
    if (selectedIndex == null)
      selectedIndex = 0;
    if (_exercises[idOfDay] == null) {
      return Exercise(name: "Exercise", id: -720);
    }
    return _exercises[idOfDay][selectedIndex];
  }
}