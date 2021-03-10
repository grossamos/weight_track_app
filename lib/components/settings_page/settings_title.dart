import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_track_app/components/main_page/main_content_pane.dart';
import 'package:weight_track_app/navigation/main_route_constants.dart';

class SettingsTitle extends StatelessWidget {
  final String _title;
  final String _subTitle;
  Function onClose;

  SettingsTitle(this._title, this._subTitle, {this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title part
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: IconButton(
                padding: EdgeInsets.zero,
                icon: SizedBox(
                  width: 25,
                  height: 25,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xffBFBFBF),
                    size: 25,
                  ),
                ),
                onPressed: () {
                  mainNavigatorKey.currentState.pop();
                  historyOfNavBar.removeLast();
                  if (onClose != null)
                    onClose();
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: TextStyle(
                      color: Color(0xff928B8B),
                      fontFamily: GoogleFonts.raleway().fontFamily,
                      fontSize: 48),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Text(
                    _subTitle,
                    style: TextStyle(
                        color: Color(0xff928B8B),
                        fontFamily: GoogleFonts.raleway().fontFamily,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
