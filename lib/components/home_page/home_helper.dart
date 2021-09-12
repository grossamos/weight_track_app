import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

final ShaderMask dayIconShader = ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (Rect bounds){
      return ui.Gradient.linear(
        Offset(0, 20),
        Offset(20, 0),
        [
          Color.fromRGBO(0xBE, 0xE8, 0x97, 1),
          Color.fromRGBO(0x05, 0xCD, 0x87, 1)
        ],
      );
    },
    child: Icon(
      Icons.circle,
      size: 40,
    )
);

final TextStyle subtitleTextStyle = TextStyle(
  fontSize: 17,
);