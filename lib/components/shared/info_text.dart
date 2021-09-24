import 'package:flutter/widgets.dart';

class InfoText extends StatelessWidget {
  final String text;
  final bool noCenter;

  InfoText(this.text, {this.noCenter = false});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontFamily: 'Raleway',
      fontSize: 24,
      color: Color(0xff737373),
    ), textAlign: noCenter? TextAlign.start : TextAlign.center,
    );
  }
}
