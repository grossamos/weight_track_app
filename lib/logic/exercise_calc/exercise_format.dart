import 'package:weight_track_app/models/exercise_instance.dart';

class ExerciseFormat{

  static String instanceToString(ExerciseInstance instance){
    return instance.reps.toString() + "x" + instance.weight.toStringAsFixed(1) + "kg";
  }
  
}