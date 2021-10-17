import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weight_track_app/components/analytics_page/analytics_analyzed_page.dart';
import 'package:weight_track_app/components/analytics_page/analytics_page.dart';
import 'package:weight_track_app/components/analytics_page/analytics_raw_page.dart';
import 'package:weight_track_app/components/home_page/exercise_log.dart';
import 'package:weight_track_app/components/home_page/home_page.dart';
import 'package:weight_track_app/components/main_page/main_content_pane.dart';
import 'package:weight_track_app/components/settings_page/settings_about.dart';
import 'package:weight_track_app/components/settings_page/settings_data.dart';
import 'package:weight_track_app/components/settings_page/settings_exercise_edit.dart';
import 'package:weight_track_app/components/settings_page/settins_day_edit.dart';
import 'package:weight_track_app/navigation/analytics_route_constants.dart';
import 'package:weight_track_app/navigation/settings_route_constants.dart';
import 'package:weight_track_app/components/settings_page/settings_page.dart';

import 'home_route_constants.dart';

// navigator Key, to use when making Navigator calls
final mainNavigatorKey = GlobalKey<NavigatorState>();

// routes in a List format
final List<String> navBarRoutes = ['/analytics', '/', '/settings'];

// routes for the Navigator in MainContentPane
Route<dynamic> mainNavigatorRoutes(RouteSettings settings){
  WidgetBuilder builder;

  if (settings.name == navBarRoutes[1]) {
    builder = (BuildContext context) => HomePage();
    historyOfNavBar.add(1);
  } else if (settings.name == navBarRoutes[0]) {
    builder = (BuildContext context) => AnalyticsPage();
    historyOfNavBar.add(0);
  } else if (settings.name == navBarRoutes[2]) {
    builder = (BuildContext context) => SettingsPage();
    historyOfNavBar.add(2);
  } else if (settings.name == homeNavigationRoutesAsList[0]) {
    builder = (BuildContext context) => ExerciseLogPage(settings.arguments);
    historyOfNavBar.add(1);
  } else if (settings.name == settingsNavigationRoutesAsList[0]){
    builder = (BuildContext context) => SettingsExerciseEdit();
    historyOfNavBar.add(2);
  } else if (settings.name == settingsNavigationRoutesAsList[1]){
    builder = (BuildContext context) => SettingsDayEdit();
    historyOfNavBar.add(2);
  } else if (settings.name == settingsNavigationRoutesAsList[2]){
    builder = (BuildContext context) => SettingsDataDelete();
    historyOfNavBar.add(2);
  } else if (settings.name == settingsNavigationRoutesAsList[3]){
    builder = (BuildContext context) => SettingsAboutPage();
    historyOfNavBar.add(2);
  } else if (settings.name == analyticsNavigationRoutesAsList[0]){
    builder = (BuildContext context) => AnalyticsRawPage();
    historyOfNavBar.add(2);
  } else if (settings.name == analyticsNavigationRoutesAsList[1]){
    builder = (BuildContext context) => AnalyticsAnalyzedPage();
    historyOfNavBar.add(2);
  }
  else {
    throw new Exception(
        "You are attempting to navigate to a page that doesn't exist: " +
            settings.name);
  }

  return MaterialPageRoute(
    builder: builder,
    settings: settings,
  );
}
