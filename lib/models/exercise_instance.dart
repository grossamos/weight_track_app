import 'package:weight_track_app/logic/exercise_calc/exercise_calc.dart';

class ExerciseInstance{
  int id;
  //stored in kilogrammes
  double weight;
  int reps;
  double strengthValue;

  ExerciseInstance({int id, int reps, double weight, double strengthValue}){
    this.id = id;
    this.weight = weight;
    this.reps = reps;

    if (strengthValue == null)
      this.strengthValue = calcStrengthValue(reps, weight);
    else
      this.strengthValue = strengthValue;
  }

  static double calcStrengthValue(int reps, double weight){
    // Strength Value is basically a theoretical one rep max
    return weight / ExerciseCalc.getGoalPercentageOfStrengthValue(reps);
  }
}