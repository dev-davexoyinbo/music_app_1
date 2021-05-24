import 'package:flutter/material.dart';
import 'package:music_app_trial_1/my_theme.dart';
import 'package:music_app_trial_1/widgets/my_bottom_navigation_bar.dart';
import 'package:music_app_trial_1/widgets/playing_widget_sm.dart';

class MyNavBar extends StatefulWidget {
  late Function _displayMediaSheetAction;
  MyNavBar({Key? key, Function? displayMediaSheetAction}) : super(key: key){
    this._displayMediaSheetAction = displayMediaSheetAction?? (bool nav){};
  }

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: MyTheme.darkColorBlur,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: PlayingWidgetSm(displayMediaSheetAction: widget._displayMediaSheetAction),
          ),
          MyBottomNavigationBar(),
        ],
      ),
    );
  } //end method build

} //end state class
