import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';
import 'package:weight_track_app/components/shared/info_text.dart';

class AnalyticsAnalyzedPage extends StatelessWidget {

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
                SettingsTitle('Analyzed Data', 'Almost a PhD thesis'),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: InfoText('To be implemented...'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}