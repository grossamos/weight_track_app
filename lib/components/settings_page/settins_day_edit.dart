import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_chip.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_fab.dart';
import 'package:weight_track_app/components/settings_page/settings_exercise_edit_state.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';

class SettingsDayEdit extends StatefulWidget {
  @override
  _SettingsDayEditState createState() => _SettingsDayEditState();
}

class _SettingsDayEditState extends State<SettingsDayEdit> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => new SettingsEditCubit(),
      child: Scaffold(
        floatingActionButton: SettingsEditFAB(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsTitle('Training Split', 'Edit the days of your split'),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 100, top: 30),
                  child: BlocBuilder<SettingsEditCubit, SettingsEditState>(
                    builder: (BuildContext context, SettingsEditState state) {
                      return FutureBuilder(
                        future: DatabaseDataUnfiltered.getDaysOfSplit(),
                        builder: (BuildContext dayContext, AsyncSnapshot<List<DayOfSplit>> daySnapshot) {
                          if (daySnapshot.data == null)
                            return Text('Loading...');
                          else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<SettingsEditChip>.generate(
                                      daySnapshot.data.length,
                                      (index) =>
                                          SettingsDayEditChip(context, daySnapshot.data[index], state.isEditing)) +
                                  (state.isEditing ? [] : [SettingsAddChip(context, false)]),
                            );
                          }
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
