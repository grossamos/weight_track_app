import 'package:sqflite/sqflite.dart';
import 'package:weight_track_app/logic/exercise_calc/exercise_calc.dart';
import 'package:weight_track_app/logic/storage/database_helper.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/exercise.dart';
import 'package:weight_track_app/models/exercise_instance.dart';
import 'package:weight_track_app/models/exercise_session.dart';

class DatabaseDataFiltered{
  static Future<ExerciseInstance> getBestInstanceOfExercise(Exercise exercise) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> mapsForSessionIds = await db.rawQuery('SELECT id FROM exerciseSessions WHERE idOfExercise=${exercise.id}');
    String sessionIds = List.generate(mapsForSessionIds.length, (index) => mapsForSessionIds[index]['id']).toString();
    sessionIds = sessionIds.substring(1, sessionIds.length - 1);
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT id, reps, weight, max( strengthValue ) FROM exerciseInstances WHERE idOfExerciseSession In ($sessionIds)');
    return ExerciseInstance(
      id: maps[0]['id'],
      reps: maps[0]['reps'],
      weight: maps[0]['weight'],
      strengthValue: maps[0]['max( strengthValue )']
    );
  }

  // TODO allow for the definition of recent (here in training Sessions) to be defined in settings
  static Future<ExerciseInstance> getRecentAverage(Exercise exercise) async {
    int defOfRecentInSessions = 8;
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> mapsForSessionIds = await db.rawQuery('SELECT id FROM exerciseSessions WHERE idOfExercise=${exercise.id} ORDER BY id DESC LIMIT $defOfRecentInSessions');
    String sessionIds = List.generate(mapsForSessionIds.length, (index) => mapsForSessionIds[index]['id']).toString();
    sessionIds = sessionIds.substring(1, sessionIds.length - 1);
    double avgStrengthValue = (await db.rawQuery('SELECT AVG( strengthValue ) FROM exerciseInstances WHERE idOfExerciseSession In ($sessionIds)'))[0]['AVG( strengthValue )'];
    int mostCommonRep = (await db.rawQuery('SELECT reps, max( id ) FROM exerciseInstances WHERE idOfExerciseSession In ($sessionIds)'))[0]['reps'];
    return ExerciseInstance(
        reps: mostCommonRep,
        weight: ExerciseCalc.getGoalPercentageOfStrengthValue(mostCommonRep) * avgStrengthValue,
        strengthValue: avgStrengthValue
    );
  }

  static Future<int> findSessionID(int exerciseID) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT date, MAX( id ) FROM exerciseSessions WHERE idOfExercise=$exerciseID');
    if (maps[0]['date'] == DateTime.now().toString())
      return maps[0]['id'];
    else
      return null;
  }

  static Future<String> getQuickInfoForDay(int idOfDay) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT name FROM exercises WHERE idOfDay=$idOfDay LIMIT 2');
    String quickInfo;
    if (maps.length >= 2)
      quickInfo = maps[0]['name'] + ", " + maps[1]['name'];
    else if (maps.length == 1)
      quickInfo = maps[0]['name'];
    else
      quickInfo = 'No exercises so far';
    return quickInfo;
  }

  static Future<String> getNameOfDay(int idOfDay) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT name FROM daysOfSplit WHERE id=$idOfDay');
    return maps[0]['name'];
  }

  static void addExerciseInstance(ExerciseInstance instance, int idOfExercise) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('SELECT id FROM exerciseSessions WHERE idOfExercise=$idOfExercise AND date=\'${today.toString()}\'');
    int sessionId;
    if (maps.isEmpty || maps == null){
      // create a new Exercise Session
      sessionId = await DatabaseDataUnfiltered.addExerciseSession(idOfExercise, ExerciseSession(date: today));
    }
    else {
      sessionId = maps[0]['id'];
    }
    DatabaseDataUnfiltered.addExerciseInstance(sessionId, instance);
  }

  Future<bool> containsExerciseInstancesForAllDays(int idOfDay) async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> mapOfExercises = await db.query('exercises', where: "idOfDay = $idOfDay");
    List<int> exerciseIds = List.generate(mapOfExercises.length, (index) => mapOfExercises[index]['id']);
    List<Map<String, dynamic>> mapOfSessions = await db.rawQuery('SELECT id FROM exerciseSessions WHERE idOfExercise IN (${exerciseIds.toString().substring(1, exerciseIds.toString().length)})');
    return mapOfSessions.length > 0;
  }

  static Future<bool> dayContainsExercises(int idOfDay) async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> mapOfExercises = await db.query('exercises', where: "idOfDay = $idOfDay", limit: 1);
    return mapOfExercises.isNotEmpty;
  }

}