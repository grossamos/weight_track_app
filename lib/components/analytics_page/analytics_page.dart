import 'package:flutter/material.dart';
import 'package:weight_track_app/navigation/main_route_constants.dart';

class AnalyticsPage extends StatelessWidget {
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Analytics",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Color.fromRGBO(0xBF, 0xBF, 0xBF, 1),
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    fontSize: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  AnalyticsOption(Icons.assignment_outlined, 'Your Raw Data', '/analytics/raw'),
                  SizedBox(height: 25),
                  AnalyticsOption(Icons.assessment_outlined, 'Your Analysed Data',  '/analytics/analyzed')
                ]
              ),
            )
          ],
        ),
      ),
    )));
  }
}

class AnalyticsOption extends StatelessWidget {

  final IconData _iconData;
  final String _navGoal;
  final String _title;

  static const _OPTION_COLOR = Color(0xff757575);


  AnalyticsOption(this._iconData, this._title, this._navGoal);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () {
      mainNavigatorKey.currentState.pushNamed(_navGoal);
    }, child: Row(
      children: [
        Icon(
          _iconData,
          size: 50,
          color: _OPTION_COLOR,
        ),
        SizedBox(width: 40,),
        Text(
          _title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _OPTION_COLOR,
            fontFamily: 'Raleway',
            fontSize: 24.0,
          ),
        )
      ],
    ));
  }
}

