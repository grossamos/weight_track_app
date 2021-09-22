import 'package:flutter/material.dart';

abstract class SettingsEditChip extends StatelessWidget {
  Widget getMainIcon();
  Widget getDeleteIcon();
  Widget getContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Spacing between rows
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: [
              getMainIcon(),
              SizedBox(width: 10),
              Expanded(child: getContent()),
              getDeleteIcon(),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsExerciseEditChip extends SettingsEditChip {
  final String exerciseName;
  final bool isBeingEdited;

  SettingsExerciseEditChip(this.exerciseName, this.isBeingEdited);
  SettingsExerciseEditChip._empty()
      : exerciseName = '',
        isBeingEdited = false;

  @override
  Widget getDeleteIcon() => TextButton(
        onPressed: () {},
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) => Color(0x4F939393)),
        ),
        child: isBeingEdited
            ? Icon(
                Icons.remove_circle_outline_outlined,
                color: Color(0xffEC64A5),
              )
            : Container(),
      );

  @override
  Widget getMainIcon() => Icon(
        Icons.check,
        color: Color(0xff51C2A4),
      );

  @override
  Widget getContent() => Text(
        exerciseName,
        style: TextStyle(fontSize: 18, fontFamily: 'Raleway'),
      );
}

class SettingsExerciseAddChip extends SettingsExerciseEditChip {
  SettingsExerciseAddChip() : super._empty();

  @override
  Icon getMainIcon() => Icon(
        Icons.check,
        color: Color(0xffC9C9C9),
      );

  @override
  Widget getContent() => Text(
        exerciseName,
        style: TextStyle(
          color: Color(0xffC9C9C9),
          fontSize: 18,
          fontFamily: 'Raleway',
        ),
      );
}

class OLDSettingsEditChip extends StatefulWidget {
  final String _title;
  final Function _onLongPress;
  final Function _onPressed;
  final Function _checkIfSelected;
  final Function _checkIfInSelectionMode;
  final Function(Function) _onIndicateSelection;

  OLDSettingsEditChip(this._title, this._onLongPress, this._onPressed, this._checkIfSelected, this._onIndicateSelection,
      this._checkIfInSelectionMode);

  @override
  _OLDSettingsEditChipState createState() => _OLDSettingsEditChipState(
      _title, _onLongPress, _onPressed, _checkIfSelected, _onIndicateSelection, _checkIfInSelectionMode);
}

class _OLDSettingsEditChipState extends State<OLDSettingsEditChip> {
  final String _title;
  final Function _onLongPress;
  final Function _onPressed;
  final Function _checkIfSelected;
  final Function _checkIfInSelectionMode;
  final Function(Function) _onIndicateSelection;

  _OLDSettingsEditChipState(this._title, this._onLongPress, this._onPressed, this._checkIfSelected,
      this._onIndicateSelection, this._checkIfInSelectionMode);

  void _indicateSelection() {
    setState(() {
      _onIndicateSelection(() => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _isSelected = _checkIfSelected();
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: GestureDetector(
        onLongPress: () {
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
          backgroundColor: _isSelected ? Color(0xffEC64A5) : Color(0xffF3F3F3),
          label: Text(
            _title,
            style: TextStyle(
              color: _isSelected ? Colors.white : Color(0xff6B6B6B),
              fontSize: 18.0,
            ),
          ),
          labelPadding: EdgeInsets.only(top: 10, right: 15, bottom: 9),
          avatar: _isSelected
              ? Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.white,
                )
              : Icon(
                  Icons.check,
                  color: Color(0xff51C2A4),
                ),
        ),
      ),
    );
  }
}
