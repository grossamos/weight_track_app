import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsEditFAB extends StatefulWidget {
  final Function _checkIfInSelectionMode;
  final Function _onPressed;
  final Function(Function) _onInit;

  SettingsEditFAB(this._checkIfInSelectionMode, this._onPressed, this._onInit);

  @override
  _SettingsEditFABState createState() => _SettingsEditFABState(_checkIfInSelectionMode, _onPressed, _onInit);
}

class _SettingsEditFABState extends State<SettingsEditFAB> {
  final Function _checkIfInSelectionMode;
  final Function _onPressed;
  final Function(Function) _onInit;

  @override
  Widget build(BuildContext context) {
    bool isInSelectionMode =_checkIfInSelectionMode();
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _onPressed();
          });
        },
        child: isInSelectionMode
            ? Icon(
          Icons.delete_forever_rounded,
          color: Colors.white,
        )
            : Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor:
        isInSelectionMode ? Color(0xffEC64A5) : Color(0xff51C2A4),
      ),
    );
  }

  _SettingsEditFABState(this._checkIfInSelectionMode, this._onPressed, this._onInit) {
    _onInit(()=>setState((){}));
  }
}