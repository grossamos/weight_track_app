import 'package:flutter/widgets.dart';

class TitleText extends StatelessWidget {
  final String title;

  TitleText(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: Color.fromRGBO(0xBF, 0xBF, 0xBF, 1),
          fontFamily: 'Raleway',
          fontSize: 48
      ),
    );
  }
}
