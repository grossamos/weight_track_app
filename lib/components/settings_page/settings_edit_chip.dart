import 'package:flutter/material.dart';

class SettingsEditChip extends StatefulWidget {
  final String _title;
  final Function _onLongPress;
  final Function _onPressed;
  final Function _checkIfSelected;
  final Function _checkIfInSelectionMode;
  final Function(Function) _onIndicateSelection;


  SettingsEditChip(this._title, this._onLongPress, this._onPressed,
      this._checkIfSelected, this._onIndicateSelection, this._checkIfInSelectionMode);

  @override
  _SettingsEditChipState createState() =>
      _SettingsEditChipState(_title, _onLongPress, _onPressed, _checkIfSelected, _onIndicateSelection, _checkIfInSelectionMode);
}

class _SettingsEditChipState extends State<SettingsEditChip> {
  final String _title;
  final Function _onLongPress;
  final Function _onPressed;
  final Function _checkIfSelected;
  final Function _checkIfInSelectionMode;
  final Function(Function) _onIndicateSelection;

  _SettingsEditChipState(this._title, this._onLongPress, this._onPressed,
      this._checkIfSelected, this._onIndicateSelection, this._checkIfInSelectionMode);

  void _indicateSelection(){
    setState(() {
      _onIndicateSelection(() => setState((){}));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _isSelected = _checkIfSelected();
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: GestureDetector(
        onLongPress: (){
          _onLongPress();
          _indicateSelection();
        },
        child: ActionChip(
          onPressed: () {
            if (_checkIfInSelectionMode()) {
              _onPressed();
              _indicateSelection();
            }
          },
          backgroundColor: _isSelected?Color(0xffEC64A5):Color(0xffF3F3F3),
          label: Text(
            _title,
            style: TextStyle(
              color: _isSelected?Colors.white:Color(0xff6B6B6B),
              fontSize: 18.0,
            ),
          ),
          labelPadding: EdgeInsets.only(top: 10, right: 15, bottom: 9),
          avatar: _isSelected?
          Icon(
            Icons.delete_forever_rounded,
            color: Colors.white,
          ):
          Icon(
            Icons.check,
            color: Color(0xff51C2A4),
          ),
        ),
      ),
    );
  }
}