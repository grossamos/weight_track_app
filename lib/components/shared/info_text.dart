import 'package:flutter/widgets.dart';

class InfoText extends StatelessWidget {
  final String text;

  InfoText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontFamily: 'Raleway',
      fontSize: 24,
      color: Color(0xff737373)
    ),);
  }
}
