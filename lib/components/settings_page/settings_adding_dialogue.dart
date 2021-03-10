import 'package:flutter/material.dart';

class SettingsAddingDialogue extends StatelessWidget {
  final Function(String) _onSave;
  final String _hint;
  TextEditingController _controller = new TextEditingController();
  SettingsAddingDialogue(this._hint, this._onSave);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Chip(
        backgroundColor: Color(0xffF3F3F3),
        label: Container(
          width: 160,
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.done,
            onSubmitted: (String name){
              _onSave(name);
              _controller.clear();
            },
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: _hint,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color(0xffB0B0B0),
                  fontSize: 18.0,
                )),
          ),
        ),
        labelPadding: EdgeInsets.only(top: 10, right: 15, bottom: 9),
        avatar: Icon(
          Icons.check,
          color: Color(0xffB0B0B0),
        ),
      ),
    );
  }
}