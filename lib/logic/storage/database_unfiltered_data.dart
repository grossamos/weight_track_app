import 'package:sqflite/sqflite.dart';
import 'package:weight_track_app/logic/storage/database_helper.dart';
import 'package:weight_track_app/models/day_of_split.dart';
import 'package:weight_track_app/models/exercise.dart';
import 'package:weight_track_app/models/exercise_instance.dart';
import 'package:weight_track_app/models/exercise_session.dart';

// TODO move add functions into separate class

class DatabaseDataUnfiltered{
  static Future<int> addDayOfSplit(DayOfSplit dayOfSplit) async {
    Database db = await DatabaseHelper.instance.database;
    int id = await db.insert('daysOfSplit',
        {'name': dayOfSplit.name});
    if (dayOfSplit.exercisesOfSplitDay != null)
      for (Exercise exercise in dayOfSplit.exercisesOfSplitDay){
        await addExercise(id, exercise);
      }
    return id;
  }

  static Future<List<DayOfSplit>> getDaysOfSplit() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.query('daysOfSplit');
    List<List<Exercise>> listOfExercises = [];

    for (Map map in maps){
      listOfExercises.add(await getExercisesOfDay(map['id']));
    }
    return List.generate(maps.length, (index){
      return DayOfSplit(
          id: maps[index]['id'],
          name: maps[index]['name'],
          exercisesOfSplitDay: listOfExercises[index]
      );
    });
  }

  static Future<List<DayOfSplit>> getEmptyDaysOfSplit() async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.query('daysOfSplit');
    return List.generate(maps.length, (index) => DayOfSplit(
        name: maps[index]['name'],
        id: maps[index]['id']
    ));
  }

  static Future<int> addExercise(int idOfDay, Exercise exercise) async {
    Database db = await DatabaseHelper.instance.database;
    int id = await db.insert('exercises',
        {'idOfDay': idOfDay, 'name': exercise.name});
    if (exercise.exerciseSessions != null && exercise.exerciseSessions.length > 0)
      for (ExerciseSession exerciseSession in exercise.exerciseSessions){
        await addExerciseSession(id, exerciseSession);
      }
    return id;
  }
  
  static Future<List<Exercise>> getExercisesOfDay(int idOfDay) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.query('exercises', where: "idOfDay = $idOfDay");
    List<List<ExerciseSession>> listOfExerciseSessions = [];

    for (Map map in maps){
      listOfExerciseSessions.add(await getExerciseSessionsOfExercise(map['id']));
    }
    return List.generate(maps.length, (index) {
      return Exercise(
          id: maps[index]['id'],
          name: maps[index]['name'],
          exerciseSessions: listOfExerciseSessions[index]
      );
    });
  }

  static Future<int> addExerciseSession(int idOfExercise, ExerciseSession exerciseSession) async {
    Database db = await DatabaseHelper.instance.database;
    int id = await db.insert('exerciseSessions',
        {'idOfExercise': idOfExercise, 'date': exerciseSession.date.toString()});
    if (exerciseSession.exerciseInstances == null)
      exerciseSession.exerciseInstances = [];
    if (exerciseSession.exerciseInstances.isNotEmpty)
      for (ExerciseInstance exerciseInstance in exerciseSession.exerciseInstances){
        await addExerciseInstance(id, exerciseInstance);
      }
    return id;
  }

  static Future<List<ExerciseSession>> getExerciseSessionsOfExercise(int idOfExercise) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.query('exerciseSessions', where: "idOfExercise = $idOfExercise");
    List<List<ExerciseInstance>> listOfInstances = [];

    for (Map map in maps){
      listOfInstances.add(await getExerciseInstancesOfSession(map['id']));
    }
    return List.generate(maps.length, (index) {
      return ExerciseSession(
          id: maps[index]['id'],
          date: DateTime.parse(maps[index]['date']),
          exerciseInstances: listOfInstances[index]
      );
    });
  }

  static Future<int> addExerciseInstance(int idOfExerciseSession, ExerciseInstance exerciseInstance) async {
    Database db = await DatabaseHelper.instance.database;
    int id = await db.insert('exerciseInstances',
        {'idOfExerciseSession': idOfExerciseSession, 'weight': exerciseInstance.weight, 'reps': exerciseInstance.reps, 'strengthValue': exerciseInstance.strengthValue});
    return id;
  }

  static Future<List<ExerciseInstance>> getExerciseInstancesOfSession(int idOfExerciseSession) async {
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.query('exerciseInstances', where: "idOfExerciseSession = $idOfExerciseSession");
    return List.generate(maps.length, (index) {
      return ExerciseInstance(
          id: maps[index]['id'],
          weight: maps[index]['weight'],
          reps: maps[index]['reps']
      );
    });
  }

  static Future<List<ExerciseInstance>> getAllExerciseInstances() async{
    Database db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> maps = await db.query('exerciseInstances');
    return List.generate(maps.length, (index) {
      return ExerciseInstance(
          id: maps[index]['id'],
          weight: maps[index]['weight'],
          reps: maps[index]['reps']
      );
    });
  }



  static Future<void> deleteDay(DayOfSplit dayOfSplit) async{
    Database db = await DatabaseHelper.instance.database;
    db.delete('daysOfSplit', where: 'id = ${dayOfSplit.id}');
    for(Exercise exercise in dayOfSplit.exercisesOfSplitDay){
      deleteExercise(exercise);
    }
  }

  static Future<void> deleteExercise(Exercise exercise) async{
    Database db = await DatabaseHelper.instance.database;
    db.delete('exercises', where: 'id = ${exercise.id}');
    for(ExerciseSession exerciseSession in exercise.exerciseSessions){
      deleteExerciseSession(exerciseSession);
    }
  }

  static Future<void> deleteExerciseSession(ExerciseSession exerciseSession) async{
    Database db = await DatabaseHelper.instance.database;
    db.delete('exerciseSessions', where: 'id = ${exerciseSession.id}');
    for(ExerciseInstance exerciseInstance in exerciseSession.exerciseInstances){
      deleteExerciseInstance(exerciseInstance);
    }
  }

  static Future<void> deleteExerciseInstance(ExerciseInstance exerciseInstance) async{
    Database db = await DatabaseHelper.instance.database;
    db.delete('exerciseInstances', where: 'id = ${exerciseInstance.id}');
  }

}

