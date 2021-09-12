import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weight_track_app/logic/exercise_calc/chart_calc.dart';
import 'package:weight_track_app/logic/exercise_calc/exercise_format.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/difficulty.dart';
import 'package:weight_track_app/models/exercise.dart';
import 'package:weight_track_app/models/exercise_instance.dart';

import 'exercise_selection_manager.dart';

class ExerciseListWidget extends StatefulWidget {
  final int _idOfDay;

  ExerciseListWidget(this._idOfDay);

  @override
  _ExerciseListWidgetState createState() => _ExerciseListWidgetState(_idOfDay);
}

class _ExerciseListWidgetState extends State<ExerciseListWidget> {

  final int _idOfDay;
  _ExerciseListWidgetState(this._idOfDay);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseDataUnfiltered.getExercisesOfDay(_idOfDay),
      builder: (BuildContext context, AsyncSnapshot<List<Exercise>> snapshot){
        if (snapshot.data == null)
          return Container();
        else {
          // TODO: somehow update the name of the exercise after the selected exercise has been loaded
          ExerciseSelectionManager.updateExercises(snapshot.data, _idOfDay);
          ExerciseSelectionManager.setLastSelectedUpdater(() => setState((){}), _idOfDay);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    child: ExerciseColumn(snapshot.data, (snapshot.data.length / 2).ceil(), (snapshot.data.length / 2).floor(), _idOfDay)
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Container(
                    child: ExerciseColumn(snapshot.data, (snapshot.data.length / 2).floor(), 0, _idOfDay)
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class ExerciseColumn extends StatelessWidget {
  final List<Exercise> exercises;
  final int lenOfColumn;
  final int startIndex;
  final int _idOfDay;

  ExerciseColumn(this.exercises, this.lenOfColumn, this.startIndex, this._idOfDay);

  ExerciseListItem getItemForIndex(int index) {
    // if (snapshot.data[index + (snapshot.data.length / 2).floor()] == null) {
    //   return Container();
    // }
    return ExerciseListItem(exercises[startIndex + index], startIndex + index, _idOfDay);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(lenOfColumn, getItemForIndex),
    );
  }
}


class ExerciseListItem extends StatefulWidget {
  final Exercise _exercise;
  final int _indexOfItem;
  final int _idOfDay;

  ExerciseListItem(this._exercise, this._indexOfItem, this._idOfDay);

  @override
  _ExerciseListItemState createState() => _ExerciseListItemState(_exercise, _indexOfItem, _idOfDay);
}

class _ExerciseListItemState extends State<ExerciseListItem> {
  final Exercise _exercise;
  final int _indexOfItem;
  final int _idOfDay;

  _ExerciseListItemState(this._exercise, this._indexOfItem, this._idOfDay);

  @override
  Widget build(BuildContext context) {
    bool _selected = ExerciseSelectionManager.checkIfSelected(_indexOfItem, _idOfDay);
    TextStyle _subtitleStyle = TextStyle(
      fontWeight: _selected?FontWeight.w600:FontWeight.w300,
      fontSize: 18.0,
      color: _selected?Colors.white:Colors.black,
    );
    TextStyle _contentStyle = TextStyle(
      fontFamily: 'Raleway',
      fontWeight: FontWeight.w200,
      fontSize: 18.0,
      color: _selected?Colors.white:Colors.black,
    );
    // TODO make AnimatedContainer work, to animate the expansion of a tile
    // TODO possible fix is to move the AnimatedContainer up to the List as a whole
    return Hero(
      tag: 'exercise_chart',
      child: AnimatedContainer(
        duration: Duration(seconds: 100),
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 22.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      // has to change when not selected
                      _selected?Color.fromRGBO(0xA9, 0xD5, 0x87, 1):Color.fromRGBO(0xF0, 0xF0, 0xF0, 1),
                      _selected?Color.fromRGBO(0x51, 0xC2, 0xA4, 1):Color.fromRGBO(0xF0, 0xF0, 0xF0, 1),
                    ]
                )
              ),
              // TODO remove selection animation
              child: FlatButton(
                padding: const EdgeInsets.all(0),
                onPressed: (){
                  if (_selected){
                    // TODO add table
                    showDialog(context: context,
                      builder: (BuildContext dialogueContext) => SimpleDialog(
                        // contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
                        title: Text(_exercise.name,
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 36,
                            color: Color(0xff676767)
                          ),
                        ),
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: DataTable(
                              columnSpacing: 10,
                                columns: [
                              DataColumn(label: Text('Reps')),
                              DataColumn(label: Text('RPE 11')),
                              DataColumn(label: Text('RPE 10')),
                              DataColumn(label: Text('RPE 8')),
                              DataColumn(label: Text('RPE 5')),
                            ], rows: List.generate(30, (int repIndex) {
                              List<DataCell> chartData = [DataCell(Text((repIndex + 1).toString()))];
                              chartData.addAll(List.generate(possibleDifficulties.length, (int diffIndex) => DataCell(FutureBuilder(
                                    future: DatabaseDataFiltered.getBestInstanceOfExercise(_exercise),
                                    builder: (BuildContext cellContext, AsyncSnapshot<ExerciseInstance> exerciseSnapshot){
                                      if (exerciseSnapshot.data == null){
                                        return Text('0');
                                      }
                                      else {
                                        return Text(ChartCalculator.getWeightForChart(repIndex + 1, possibleDifficulties[diffIndex], exerciseSnapshot.data.strengthValue).round().toString());
                                      }
                                    },
                                  ))
                                  ));
                              return DataRow(cells: chartData);
                            }
                            )),
                          ),
                        ],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
                      )
                    );
                  }
                  ExerciseSelectionManager.updateSelectedIndexes(_indexOfItem, _idOfDay);
                  ExerciseSelectionManager.updateListeners(_idOfDay);
                  ExerciseSelectionManager.callLastSelectedUpdater(_idOfDay);
                  ExerciseSelectionManager.setLastSelectedUpdater(() => setState((){print("Updating..");}), _idOfDay);
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 21),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _exercise.name,
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 24.0,
                          color: _selected?Colors.white:Colors.black
                        ),
                      ),
                      Divider(
                        thickness: 1.0,
                        color: _selected?Colors.white:Colors.black,
                      ),
                      SizedBox(
                        height: _selected?10.0:5.0,
                      ),
                      Text(
                        "Average",
                        style: _subtitleStyle,
                      ),
                      FutureBuilder(
                        future: DatabaseDataFiltered.getRecentAverage(_exercise),
                        builder: (BuildContext context, AsyncSnapshot<ExerciseInstance> snapshot){
                          if (snapshot.data == null)
                            return Text('0x0kg', style: _contentStyle);
                          else
                            return Text(ExerciseFormat.instanceToString(snapshot.data), style: _contentStyle);
                        },
                      ),
                      !_selected?Container():Text(
                        "Maximum",
                        style: _subtitleStyle,
                      ),
                      !_selected?Container():FutureBuilder(
                        future: DatabaseDataFiltered.getBestInstanceOfExercise(_exercise),
                        builder: (BuildContext context, AsyncSnapshot<ExerciseInstance> snapshot){
                          if (snapshot.data == null)
                            return Text('0x0kg', style: _contentStyle);
                          else
                            return Text(ExerciseFormat.instanceToString(snapshot.data), style: _contentStyle);
                        },
                      ),
                      SizedBox(
                        height: _selected?10.0:5.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}