import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weight_track_app/components/settings_page/settings_tile.dart';
import 'package:weight_track_app/navigation/main_route_constants.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 110.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                "Your\nSettings",
                style: TextStyle(
                    color: Color.fromRGBO(0xBF, 0xBF, 0xBF, 1),
                    fontFamily: 'Raleway',
                    fontSize: 48
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SettingsTile(Icons.fitness_center_rounded, 'Exercises', (){mainNavigatorKey.currentState.pushNamed('/settings/exercise_edit');}),
                    SizedBox(height: 22),
                    SettingsTile(Icons.calendar_today_rounded, 'Training Split', (){mainNavigatorKey.currentState.pushNamed('/settings/day_edit');})
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SettingsTile(Icons.folder_open_rounded, 'Data', (){mainNavigatorKey.currentState.pushNamed('/settings/data');}),
                    SizedBox(height: 22),
                    SettingsTile(Icons.info_rounded, 'About', (){Fluttertoast.showToast(msg: 'App made by Ultraman');})
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
