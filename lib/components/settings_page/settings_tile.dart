import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SettingsTile extends StatelessWidget {
  final IconData _icon;
  final String _text;
  final Function _onPressed;

  SettingsTile(this._icon, this._text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    // TODO replace Width with expanded or something more agnostic
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      height: 241.0,
      decoration: BoxDecoration(
          color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(15)),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: _onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds){
                  return ui.Gradient.linear(
                    Offset(24.0, 4.0),
                    Offset(4.0, 24.0),
                    [
                      Color(0xffA5D488),
                      Color(0xff55C3A3)
                    ],
                  );
                },
                child: Icon(_icon, size: 55,)
            ),
            SizedBox(height: 5,),
            Text(
              _text,
              style: TextStyle(
                  fontSize: 18, color: Color(0xff55C3A3)),
            )
          ],
        ),
      ),
    );
  }
}
