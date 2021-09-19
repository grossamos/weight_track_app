import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/logic/exercise_calc/chart_calc.dart';
import 'package:weight_track_app/logic/exercise_calc/exercise_format.dart';
import 'package:weight_track_app/logic/storage/database_filtered_data.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/difficulty.dart';
import 'package:weight_track_app/models/exercise.dart';
import 'package:weight_track_app/models/exercise_instance.dart';

import 'exercise_log_cubit.dart';
import 'exercise_log_state.dart';

// TODO make stateless
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
      builder: (BuildContext context, AsyncSnapshot<List<Exercise>> exercisesSnapshot) {
        if (exercisesSnapshot.data == null)
          return Container();
        else {
          if (context.read<ExerciseLogCubit>().state.selectedExercise.name == 'Exercise') {
            context.read<ExerciseLogCubit>().changeSelectedExercise(0, exercisesSnapshot.data[0]);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                      child: ExerciseColumn(exercisesSnapshot.data, (exercisesSnapshot.data.length / 2).ceil(),
                          (exercisesSnapshot.data.length / 2).floor())),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Container(
                      child: ExerciseColumn(exercisesSnapshot.data, (exercisesSnapshot.data.length / 2).floor(), 0)),
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

  ExerciseColumn(this.exercises, this.lenOfColumn, this.startIndex);

  ExerciseListItem getItemForIndex(int index) {
    return ExerciseListItem(exercises[startIndex + index], startIndex + index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(lenOfColumn, getItemForIndex),
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise _exercise;
  final int _indexOfItem;

  ExerciseListItem(this._exercise, this._indexOfItem);

  @override
  Widget build(BuildContext context) {
    // TODO make AnimatedContainer work, to animate the expansion of a tile
    // TODO possible fix is to move the AnimatedContainer up to the List as a whole
    return BlocBuilder<ExerciseLogCubit, ExerciseLogState>(
        // bloc: context.read<ExerciseLogCubit>(),
        builder: (BuildContext context, ExerciseLogState state) {
      bool _selected = state.selectedIndex == _indexOfItem;
      TextStyle _subtitleStyle = TextStyle(
        fontWeight: _selected ? FontWeight.w600 : FontWeight.w300,
        fontSize: 18.0,
        color: _selected ? Colors.white : Colors.black,
      );
      TextStyle _contentStyle = TextStyle(
        fontFamily: 'Raleway',
        fontWeight: FontWeight.w200,
        fontSize: 18.0,
        color: _selected ? Colors.white : Colors.black,
      );
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
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomLeft, colors: [
                      // has to change when not selected
                      _selected ? Color.fromRGBO(0xA9, 0xD5, 0x87, 1) : Color.fromRGBO(0xF0, 0xF0, 0xF0, 1),
                      _selected ? Color.fromRGBO(0x51, 0xC2, 0xA4, 1) : Color.fromRGBO(0xF0, 0xF0, 0xF0, 1),
                    ])),
                child: TextButton(
                  onPressed: () {
                    if (_selected) {
                      showDialog(
                          context: context,
                          builder: (BuildContext dialogueContext) => SimpleDialog(
                                title: Text(
                                  _exercise.name,
                                  style: TextStyle(fontFamily: 'Raleway', fontSize: 36, color: Color(0xff676767)),
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
                                        ],
                                        rows: List.generate(30, (int repIndex) {
                                          List<DataCell> chartData = [DataCell(Text((repIndex + 1).toString()))];
                                          chartData.addAll(List.generate(
                                              possibleDifficulties.length,
                                              (int diffIndex) => DataCell(FutureBuilder(
                                                    future: DatabaseDataFiltered.getBestInstanceOfExercise(_exercise),
                                                    builder: (BuildContext cellContext,
                                                        AsyncSnapshot<ExerciseInstance> bestInstanceSnapshot) {
                                                      if (bestInstanceSnapshot.data == null) {
                                                        return Text('0');
                                                      } else {
                                                        return Text(ChartCalculator.getWeightForChart(
                                                                repIndex + 1,
                                                                possibleDifficulties[diffIndex],
                                                                bestInstanceSnapshot.data.strengthValue)
                                                            .round()
                                                            .toString());
                                                      }
                                                    },
                                                  ))));
                                          return DataRow(cells: chartData);
                                        })),
                                  ),
                                ],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
                              ));
                    } else {
                      context.read<ExerciseLogCubit>().changeSelectedExercise(_indexOfItem, _exercise);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 21),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _exercise.name,
                          style: TextStyle(
                              fontFamily: 'Raleway', fontSize: 24.0, color: _selected ? Colors.white : Colors.black),
                        ),
                        Divider(
                          thickness: 1.0,
                          color: _selected ? Colors.white : Colors.black,
                        ),
                        SizedBox(
                          height: _selected ? 10.0 : 5.0,
                        ),
                        Text(
                          "Average",
                          style: _subtitleStyle,
                        ),
                        FutureBuilder(
                          future: DatabaseDataFiltered.getRecentAverage(_exercise),
                          builder: (BuildContext context, AsyncSnapshot<ExerciseInstance> recentAverageSnapshot) {
                            if (recentAverageSnapshot.data == null)
                              return Text('0x0kg', style: _contentStyle);
                            else
                              return Text(ExerciseFormat.instanceToString(recentAverageSnapshot.data),
                                  style: _contentStyle);
                          },
                        ),
                        !_selected
                            ? Container()
                            : Text(
                                "Maximum",
                                style: _subtitleStyle,
                              ),
                        !_selected
                            ? Container()
                            : FutureBuilder(
                                future: DatabaseDataFiltered.getBestInstanceOfExercise(_exercise),
                                builder: (BuildContext context, AsyncSnapshot<ExerciseInstance> bestInstanceSnapshot) {
                                  if (bestInstanceSnapshot.data == null)
                                    return Text('0x0kg', style: _contentStyle);
                                  else
                                    return Text(ExerciseFormat.instanceToString(bestInstanceSnapshot.data),
                                        style: _contentStyle);
                                },
                              ),
                        SizedBox(
                          height: _selected ? 10.0 : 5.0,
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
    });
  }
}
