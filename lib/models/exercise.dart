import 'package:weight_track_app/models/exercise_session.dart';
import 'package:weight_track_app/models/nameable.dart';

class Exercise implements Nameable{
  int id;
  List<ExerciseSession> exerciseSessions;
  String name;

  Exercise({this.id, this.name, this.exerciseSessions});
}