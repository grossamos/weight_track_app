import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/components/settings_page/settings_exercise_edit_state.dart';

class SettingsEditFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsEditCubit, SettingsEditState>(
      builder: (BuildContext context, SettingsEditState state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<SettingsEditCubit>(context).flipEditMode();
            },
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            backgroundColor:
            state.isEditing ? Color(0xffEC64A5) : Color(0xff51C2A4),
          ),
        );
      },
    );
  }
}