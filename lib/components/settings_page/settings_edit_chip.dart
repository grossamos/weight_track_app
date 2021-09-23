import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_track_app/components/settings_page/settings_exercise_edit_state.dart';
import 'package:weight_track_app/logic/storage/database_unfiltered_data.dart';
import 'package:weight_track_app/models/day_of_split.dart';
import 'package:weight_track_app/models/exercise.dart';
import 'package:weight_track_app/models/nameable.dart';

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

abstract class SettingsGeneralEditChip<T extends Nameable> extends SettingsEditChip {
  final bool isBeingEdited;
  final T chipModel;
  final BuildContext context;

  SettingsGeneralEditChip(this.context, this.chipModel, this.isBeingEdited);

  void onDelete();
  
  @override
  Widget getDeleteIcon() => TextButton(
    onPressed: () {
      onDelete();
    },
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
    chipModel.name,
    style: TextStyle(fontSize: 18, fontFamily: 'Raleway'),
  );
}

class SettingsExerciseEditChip extends SettingsGeneralEditChip<Exercise> {
  SettingsExerciseEditChip(BuildContext context, Exercise exercise, bool isBeingEdited) : super(context, exercise, isBeingEdited);

  @override
  void onDelete() {
    DatabaseDataUnfiltered.deleteExercise(chipModel).then((value) {
      BlocProvider.of<SettingsEditCubit>(context).changeSeed();
    });
  }
  
}

class SettingsDayEditChip extends SettingsGeneralEditChip<DayOfSplit> {
  SettingsDayEditChip(BuildContext context, DayOfSplit day, bool isBeingEdited) : super(context, day, isBeingEdited);

  @override
  void onDelete() {
    DatabaseDataUnfiltered.deleteDay(chipModel).then((value) {
      BlocProvider.of<SettingsEditCubit>(context).changeSeed();
    });
  }

}

class SettingsAddChip extends SettingsEditChip {
  final BuildContext context;
  final bool autofocusEnabled;

  SettingsAddChip(this.context, this.autofocusEnabled);

  @override
  Icon getMainIcon() => Icon(
    Icons.check,
    color: Color(0xffC9C9C9),
  );

  @override
  Widget getContent() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: TextField(
      autofocus: autofocusEnabled,
      controller: new TextEditingController(),
      textInputAction: TextInputAction.done,
      onSubmitted: (String _) {
        BlocProvider.of<SettingsEditCubit>(context).exitNewAddingMode();
      },
      onChanged: (String tmpExerciseName) {
        SettingsAddStateSingleton.name = tmpExerciseName;
      },
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Raleway',
      ),
      decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintText: 'Enter Name Here',
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Color(0xffC9C9C9),
            fontSize: 18,
            fontFamily: 'Raleway',
          )
      ),
    ),
  );

  @override
  Widget getDeleteIcon() {
    return Container();
  }
}