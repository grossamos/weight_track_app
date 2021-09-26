import 'package:flutter/material.dart';
import 'package:weight_track_app/components/settings_page/settings_edit_chip.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';
import 'package:weight_track_app/logic/app_settings.dart';
import 'package:weight_track_app/logic/storage/database_helper.dart';

class SettingsDataDelete extends StatefulWidget {
  @override
  _SettingsDataDeleteState createState() => _SettingsDataDeleteState();
}

class _SettingsDataDeleteState extends State<SettingsDataDelete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingsTitle('Database', 'Change  how you manage data'),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 100),
                    child: FutureBuilder(
                      future: AppSettings.initialize(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SettingsSmartLoggingChip(invertSmartLogging, AppSettings.smartLoggingIsEnabled),
                            SettingsDeleteEverythingChip(context)
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void invertSmartLogging(bool _) {
    setState(() {
      AppSettings.smartLoggingIsEnabled = !AppSettings.smartLoggingIsEnabled;
    });
  }
}

class SettingsSmartLoggingChip extends SettingsEditChip {
  final Function(bool) onFlip;
  final bool isEnabled;

  SettingsSmartLoggingChip(this.onFlip, this.isEnabled);

  @override
  Widget getContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        'Enable smart logging',
        style: TextStyle(fontSize: 18, fontFamily: 'Raleway'),
      ),
    );
  }

  @override
  Widget getDeleteIcon() {
    return Switch(
      value: isEnabled,
      onChanged: onFlip,
      activeColor: Color(0xff51C2A4),
    );
  }

  @override
  Widget getMainIcon() {
    return Container();
  }
}

class SettingsDeleteEverythingChip extends SettingsEditChip {
  final BuildContext _context;

  SettingsDeleteEverythingChip(this._context);

  @override
  Widget getContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        'DANGEROUS: Delete all data',
        style: TextStyle(fontSize: 18, fontFamily: 'Raleway'),
      ),
    );
  }

  @override
  Widget getDeleteIcon() {
    return IconButton(
        onPressed: () {
          showDialog(
              context: _context,
              barrierDismissible: true,
              builder: (BuildContext dialogueContext)
          {
            return AlertDialog(
              title: Text('Delete all Data?'),
              content: Text('Are you sure you want to delete your entire Database?\nThis action cannot be undone.'),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(dialogueContext).pop();
                  },
                ),
                TextButton(
                  child: Text("Delete"),
                  onPressed: () {
                    DatabaseHelper.instance.clearDB();
                    Navigator.of(dialogueContext).pop();
                  },
                ),
              ],
            );
          });
        },
        icon: Icon(Icons.delete_forever_outlined, color: Color(0xffEC64A5)),
        visualDensity: VisualDensity.compact);
  }

  @override
  Widget getMainIcon() {
    return Container();
  }
}
