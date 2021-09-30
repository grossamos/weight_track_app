import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_chip.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';

class SettingsAboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsTitle('About', 'Who created all those bugs?'),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 100),
                    child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SettingsAboutChip('https://www.amosgross.com', 'Author: ', 'Amos Groß'),
                            SettingsAboutChip('https://github.com/grossamos/weight_track_app', 'Source Code: ', 'Github')
                          ],
                        )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsAboutChip extends SettingsEditChip {
  final String _preamble;
  final String _linkText;
  final String _url;

  SettingsAboutChip(this._url, this._preamble, this._linkText);

  @override
  Widget getContent() {
    return TextButton(
      onPressed: () async {
        await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Text(
              _preamble,
              style: TextStyle(fontSize: 18, fontFamily: 'Raleway', color: Color(0xff737373)),
            ),
            Text(
              _linkText,
              style: TextStyle(fontSize: 18, fontFamily: 'Raleway', decoration: TextDecoration.underline, color: Color(0xff51C2A4)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget getDeleteIcon() {
    return Container();
  }

  @override
  Widget getMainIcon() {
    return Container();
  }

}

