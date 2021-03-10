import 'package:weight_track_app/models/exercise.dart';

class DayOfSplit{
  int id;
  List<Exercise> exercisesOfSplitDay;
  String name;

  DayOfSplit({this.id, this.name, this.exercisesOfSplitDay});
}