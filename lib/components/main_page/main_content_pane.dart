import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weight_track_app/navigation/main_route_constants.dart';
import 'dart:ui' as ui;

List<int> historyOfNavBar = [];

// StatefulWidget that renders Icons, labels, etc
class MainContentPane extends StatefulWidget {
  @override
  _MainContentPaneState createState() => _MainContentPaneState();
}

class _MainContentPaneState extends State<MainContentPane> {
  // index used for Nav Bar
  int _currentNavBarIndex = 1;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMainScreen(),
      builder: (BuildContext futureContext, AsyncSnapshot<Widget> widget) {
        if (widget.data == null) return Container();
        return widget.data;
      },
    );
  }

  Future<Widget> getMainScreen() async {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          child: WillPopScope(
            onWillPop: () async {
              if (mainNavigatorKey.currentState.canPop()) {
                historyOfNavBar.removeLast();
                if (historyOfNavBar.last != _currentNavBarIndex) _currentNavBarIndex = historyOfNavBar.last;
                mainNavigatorKey.currentState.pop();
                return false;
              }
              return true;
            },
            child: Navigator(
              key: mainNavigatorKey,
              initialRoute: '/',
              onGenerateRoute: mainNavigatorRoutes,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  height: 72.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: getNavBarIcons(),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }

  List<Widget> getNavBarIcons() {
    if (_currentNavBarIndex != 0 && _currentNavBarIndex != 1 && _currentNavBarIndex != 2)
      throw UnimplementedError("There is no nav bar index: " + _currentNavBarIndex.toString());

    Color unselectedColor = Color.fromRGBO(0x75, 0x75, 0x75, 1);
    Color selectedColor1 = Color.fromRGBO(0x3c, 0x8c, 0xF3, 1);
    Color selectedColor2 = Color.fromRGBO(0x14, 0xCB, 0xF5, 1);
    List<IconData> icons = [Icons.analytics_rounded, Icons.home_rounded, Icons.settings_rounded];

    return List.generate(
        icons.length,
        (index) => IconButton(
            iconSize: 33.0,
            // Shader Mask needed for Gradient
            icon: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return ui.Gradient.linear(
                    Offset(4.0, 24.0),
                    Offset(24.0, 4.0),
                    [
                      _currentNavBarIndex == index ? selectedColor1 : unselectedColor,
                      _currentNavBarIndex == index ? selectedColor2 : unselectedColor,
                    ],
                  );
                },
                child: Icon(icons[index])),
            onPressed: () {
              setState(() {
                _currentNavBarIndex = index;
                mainNavigatorKey.currentState.pushNamed(navBarRoutes[index]);
              });
            }));
  }
}
