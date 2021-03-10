import 'package:weight_track_app/models/difficulty.dart';
import 'package:weight_track_app/models/exercise_instance.dart';

class ExerciseCalc{

  static double getGoalPercentageOfStrengthValue(int reps, {Difficulty difficulty}){

    // account for difficulty
    if (difficulty != null){
      reps += difficultyToRepsShort(difficulty);
    }

    // big dictionary of results
    Map<int, double> mapOfRepRanges = {
      0: 1, 1: 1, 2: 0.95, 3: 0.92, 4: 0.89, 5: 0.86, 6: 0.83, 7: 0.81, 8: 0.79, 9: 0.77, 10: 0.75,
      11: 0.73, 12: 0.71, 13: 0.7, 14: 0.68, 15: 0.67, 16: 0.65, 17: 0.64, 18: 63, 19: 62, 20:61
    };

    // quadratic function stops being applicable after 24 reps
    if (reps > 20){
      return 1 / (reps * 0.081);
    }

    // for 0 and negative values (cause that's not really possible)
    if (mapOfRepRanges[reps] == null){
      return 1;
    }

    return mapOfRepRanges[reps];
  }

  static ExerciseInstance compareInstances(ExerciseInstance instanceOne, ExerciseInstance instanceTwo){
    if (instanceOne.strengthValue < instanceTwo.strengthValue)
      return instanceTwo;
    else
      return instanceOne;
  }
}
