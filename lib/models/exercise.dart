import 'package:weight_track_app/models/exercise_session.dart';

class Exercise{
  int id;
  List<ExerciseSession> exerciseSessions;
  String name;

  Exercise({this.id, this.name, this.exerciseSessions});
}