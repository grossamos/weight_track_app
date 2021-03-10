import 'package:weight_track_app/models/day_of_split.dart';

class SettingsDayEditSelectionManager{
  static bool _isInSelectionMode = false;
  static List<DayOfSplit> _selectedDays = [];
  static List<Function> _selectedListeners = [];
  static Function _fabListener;

  // functions to deal with Selection State Management
  static bool isInSelectionMode() {
    return _isInSelectionMode;
  }
  static void putInSelectionMode() {
    _isInSelectionMode = true;
    try{
      _fabListener();
    }catch (e){}
  }
  static void exitSelectionMode() {
    _isInSelectionMode = false;
    try{
      _fabListener();
    }catch (e){}
    clearSelection();
  }
  static void addFabListener(Function listener){
    _fabListener = listener;
  }

  // functions to deal with changing what is selected
  static void addDayToSelection(DayOfSplit dayOfSplit, Function listener){
    if (!_selectedDays.contains(dayOfSplit)){
      _selectedDays.add(dayOfSplit);
      _selectedListeners.add(listener);
    }
  }
  static void removeFromSelection(DayOfSplit dayOfSplit){
    if (_selectedDays.contains(dayOfSplit)){
      _selectedDays.remove(dayOfSplit);
    }
  }
  static void clearSelection() {
    _selectedDays = [];
    for (Function f in _selectedListeners)
      try {
        f();
      } catch (exception) {
        print("exception");
      }
    _selectedListeners = [];
  }
  static bool isSelected(DayOfSplit dayOfSplit){
    return _selectedDays.contains(dayOfSplit);
  }

  // functions for using the data
  static List<DayOfSplit> getSelectedDaysOfSplit(){
    return _selectedDays;
  }


}