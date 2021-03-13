import 'package:weight_track_app/logic/exercise_calc/exercise_calc.dart';
import 'package:weight_track_app/models/difficulty.dart';

class ChartCalculator {
  static List<double> getWeightsForRep(int reps, double strengthValue) {
    return List.generate(
        possibleDifficulties.length,
        (index) =>
            ExerciseCalc.getGoalPercentageOfStrengthValue(reps,
                difficulty: possibleDifficulties[
                    possibleDifficulties.length - 1 - index]) *
            strengthValue);
  }

  static double getWeightForChart(int reps, Difficulty difficulty, double strengthValue){
    return ExerciseCalc.getGoalPercentageOfStrengthValue(reps, difficulty: difficulty) * strengthValue;
  }
}
