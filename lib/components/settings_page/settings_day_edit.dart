import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weight_track_app/components/settings_page/settings_adding_dialogue.dart';
import 'package:weight_track_app/components/settings_page/settings_day_edit_selection_manager.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_chip.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_fab.dart';
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
    return Scaffold(
      floatingActionButton: SettingsEditFAB(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsTitle('Training Split', 'Edit the days of your split', onClose: (){
                SettingsDayEditSelectionManager.exitSelectionMode();
              },),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 100, top: 30),
                child: FutureBuilder(
                  future: DatabaseDataUnfiltered.getDaysOfSplit(),
                  builder: (BuildContext dayContext,
                      AsyncSnapshot<List<DayOfSplit>> daySnapshot) {
                    if (daySnapshot.data == null)
                      return Text('Loading...');
                    else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                daySnapshot.data.length,
                                (index) => OLDSettingsEditChip(
                                    daySnapshot.data[index].name,
                                    () {
                                      SettingsDayEditSelectionManager
                                          .putInSelectionMode();
                                    },
                                    () {},
                                    () {
                                      return SettingsDayEditSelectionManager
                                          .isSelected(daySnapshot.data[index]);
                                    },
                                    (Function listener) {
                                      if (!SettingsDayEditSelectionManager
                                          .isSelected(daySnapshot.data[index])) {
                                        SettingsDayEditSelectionManager
                                            .addDayToSelection(
                                                daySnapshot.data[index],
                                                listener);
                                      } else {
                                        SettingsDayEditSelectionManager
                                            .removeFromSelection(
                                                daySnapshot.data[index]);
                                      }
                                    },
                                    () {
                                      return SettingsDayEditSelectionManager
                                          .isInSelectionMode();
                                    })),
                          ),
                          SettingsAddingDialogue("Enter new Day/Split",
                              (String newDayName) {
                            DatabaseDataUnfiltered.addDayOfSplit(new DayOfSplit(
                                name: newDayName, exercisesOfSplitDay: []));
                            Fluttertoast.showToast(msg: "Saving...");
                          })
                        ],
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
