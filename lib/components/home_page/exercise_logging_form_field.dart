import 'package:flutter/material.dart';

class ExerciseLoggingFormField extends StatelessWidget {
  final Function gvnOnSave;
  final Function finalizeData;
  final String _label;
  final double _width;
  final bool isLastField;

  ExerciseLoggingFormField(this.gvnOnSave, this._label, this._width, {this.isLastField = false, this.finalizeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 25),
        child: TextFormField(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelStyle: TextStyle(
              color: Color(0xff727272),
            ),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffA5D488), width: 2.0)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff55C3A3), width: 2.0)),
            labelText: _label,
          ),
          textInputAction: isLastField ? TextInputAction.done : TextInputAction.next,
          keyboardType: TextInputType.number,
          validator: loggingValidate,
          onSaved: gvnOnSave,
          onEditingComplete: finalizeData,
        ),
      ),
    );
  }

  String loggingValidate(String s) {
    if (s == '') {
      return 'Please provide a value';
    }
    try {
      double.parse(s);
    } catch (FormatException) {
      return "Please enter a valid number";
    }
    return null;
  }
}
