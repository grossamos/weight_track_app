import 'package:flutter/material.dart';
import 'package:weight_track_app/components/settings_page/settings_title.dart';
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
                SettingsTitle('Database', 'Delete all your Data'),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, bottom: 100, top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlatButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext dialogueContext){
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
                                }
                              );
                            },
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Color(0xffEC64A5),
                              size: 300,
                            )
                        ),
                        Text(
                          "RESET",
                          style: TextStyle(
                            color: Color(0xffEC64A5),
                            fontSize: 36,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
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
}
