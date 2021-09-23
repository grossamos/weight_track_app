import 'package:flutter/material.dart';
import 'package:weight_track_app/components/shared/info_text.dart';

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
              child: InfoText('To be implemented...'),
            )
          ],
        ),
      ),
    )));
  }
}
