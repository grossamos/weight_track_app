import 'package:weight_track_app/models/exercise.dart';
import 'package:weight_track_app/models/nameable.dart';

class DayOfSplit implements Nameable{
  int id;
  List<Exercise> exercisesOfSplitDay;
  String name;

  DayOfSplit({this.id, this.name, this.exercisesOfSplitDay});
}