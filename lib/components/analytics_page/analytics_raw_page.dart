import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';
import 'package:weight_track_app/components/shared/info_text.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/exercise_instance.dart';

class AnalyticsRawPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SettingsTitle('Raw Data', 'Your Data, as raw as it gets'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 33.0, vertical: 20.0),
                  child: AnalyticsRawDataTable(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnalyticsRawDataTable extends StatefulWidget {

  @override
  _AnalyticsRawDataTableState createState() => _AnalyticsRawDataTableState();
}

class _AnalyticsRawDataTableState extends State<AnalyticsRawDataTable> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseDataUnfiltered.getAllExerciseInstances(),
      builder: (BuildContext context, AsyncSnapshot<List<ExerciseInstance>> exerciseInstancesAsSnapshot) {
        if (exerciseInstancesAsSnapshot.data == null || exerciseInstancesAsSnapshot.data.isEmpty) {
          return InfoText('No Instances Recorded so far');
        } else return Container(
          width: double.infinity,
          child: DataTable(
              columnSpacing: 10,
              horizontalMargin: 0,
              columns: [
                DataColumn(label: Container()),
                DataColumn(label: AnalyticsDataColumnText('Split Day', isMainText: true)),
                DataColumn(label: AnalyticsDataColumnText('Exercise')),
                DataColumn(label: AnalyticsDataColumnText('Reps')),
                DataColumn(label: AnalyticsDataColumnText('Weight')),
              ],
              rows: List.generate(exerciseInstancesAsSnapshot.data.length,
                      (int index) => generateRow(exerciseInstancesAsSnapshot.data[exerciseInstancesAsSnapshot.data.length - index - 1])
              )
          ),
        );
      },
    );
  }

  Widget getInstanceMetadata(int index, int id) {
    return FutureBuilder(
      future: DatabaseDataUnfiltered.getNameAndDayOfInstance(id),
      builder: (BuildContext context, AsyncSnapshot<List<String>> infoSnapshot) {
        if (infoSnapshot.data == null)
          return Text('loading');
        else
          return Text(infoSnapshot.data[index]);
      },
    );
  }

  DataRow generateRow(ExerciseInstance instance) {
    return DataRow(cells: [
      DataCell(
          Icon(
              Icons.delete_outline_outlined
          ),
          onTap: () {
            DatabaseDataUnfiltered.deleteExerciseInstance(instance);
            setState(() {});
          }
      ),

      // Split Day
      DataCell(getInstanceMetadata(0, instance.id)),

      // Exercise
      DataCell(getInstanceMetadata(1, instance.id)),

      // Reps
      DataCell(Text(instance.reps.toString())),

      // Weight
      DataCell(Text(instance.weight.toString())),

    ]);
  }
}


class AnalyticsDataColumnText extends StatelessWidget {

  final String _textContent;
  final bool isMainText;


  AnalyticsDataColumnText(this._textContent, {this.isMainText = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      _textContent + (isMainText? '' : ''),
      style: TextStyle(
        color: Color(0xffA9A8A8),
        fontFamily: 'Raleway',
        fontSize: 16
      ),
    );
  }
}
