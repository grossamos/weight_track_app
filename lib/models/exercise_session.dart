import 'exercise_instance.dart';

class ExerciseSession{
  int id;
  List<ExerciseInstance> exerciseInstances = [];
  DateTime date;

  ExerciseSession({this.id, this.date, this.exerciseInstances});
}

